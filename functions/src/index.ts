import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();

/**
 * 새 엔트리 생성 시 정원 상태 업데이트
 */
export const onEntryCreated = functions.firestore
  .document('entries/{uid}/{month}/{entryId}')
  .onCreate(async (snap, context) => {
    const { uid } = context.params;
    const entry = snap.data();

    const gardenRef = db.doc(`garden/${uid}/state`);

    return db.runTransaction(async (transaction) => {
      const gardenDoc = await transaction.get(gardenRef);

      if (!gardenDoc.exists) {
        // 정원 상태 초기화
        transaction.set(gardenRef, {
          userId: uid,
          experience: 0,
          level: 1,
          streakDays: 0,
          lastEntryDate: null,
          placedItems: [],
          unlockedItems: [],
          currentTheme: 'default',
          updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        });
      }

      const garden = gardenDoc.data() || {};
      const now = new Date();
      const lastEntry = garden.lastEntryDate?.toDate();

      // 경험치 계산 (금액에 따라 3~10)
      const amount = Math.abs(entry.amount || 0);
      const expGain = Math.min(Math.max(Math.floor(amount / 10000), 3), 10);

      // 스트릭 계산
      let newStreak = garden.streakDays || 0;
      if (lastEntry) {
        const hoursDiff = (now.getTime() - lastEntry.getTime()) / (1000 * 60 * 60);
        if (hoursDiff <= 36) {
          // 36시간 이내면 스트릭 유지
          const daysDiff = Math.floor(hoursDiff / 24);
          if (daysDiff >= 1) {
            newStreak += 1;
          }
        } else {
          // 스트릭 리셋
          newStreak = 1;
        }
      } else {
        newStreak = 1;
      }

      // 레벨 계산 (100 경험치당 1레벨)
      const newExp = (garden.experience || 0) + expGain;
      const newLevel = Math.floor(newExp / 100) + 1;

      transaction.update(gardenRef, {
        experience: newExp,
        level: newLevel,
        streakDays: newStreak,
        lastEntryDate: admin.firestore.Timestamp.now(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Garden updated for ${uid}: +${expGain} exp, streak: ${newStreak}`);
    });
  });

/**
 * 구독 웹훅 처리 (RevenueCat)
 */
export const handleSubscriptionWebhook = functions.https.onRequest(async (req, res) => {
  try {
    const event = req.body;

    if (event.type === 'INITIAL_PURCHASE' || event.type === 'RENEWAL') {
      const uid = event.app_user_id;
      const expiresAt = new Date(event.expiration_at_ms);

      await db.doc(`users/${uid}`).update({
        isPremium: true,
        premiumExpiresAt: admin.firestore.Timestamp.fromDate(expiresAt),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Premium activated for ${uid} until ${expiresAt}`);
    } else if (event.type === 'CANCELLATION' || event.type === 'EXPIRATION') {
      const uid = event.app_user_id;

      await db.doc(`users/${uid}`).update({
        isPremium: false,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Premium deactivated for ${uid}`);
    }

    res.status(200).send('OK');
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).send('Error');
  }
});

/**
 * CS 티켓 생성 시 Slack 알림
 */
export const onTicketCreated = functions.firestore
  .document('tickets/{uid}/{ticketId}')
  .onCreate(async (snap, context) => {
    const ticket = snap.data();
    const { uid, ticketId } = context.params;

    const slackWebhookUrl = functions.config().slack?.webhook_url;

    if (!slackWebhookUrl) {
      console.log('Slack webhook URL not configured');
      return;
    }

    const message = {
      text: `🎫 새로운 고객 문의`,
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: `*새로운 고객 문의*\n*사용자:* ${uid}\n*티켓 ID:* ${ticketId}`,
          },
        },
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: `*제목:* ${ticket.subject || '제목 없음'}\n*내용:*\n${ticket.message || '내용 없음'}`,
          },
        },
      ],
    };

    try {
      const response = await fetch(slackWebhookUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(message),
      });

      if (!response.ok) {
        throw new Error(`Slack API error: ${response.statusText}`);
      }

      console.log(`Slack notification sent for ticket ${ticketId}`);
    } catch (error) {
      console.error('Failed to send Slack notification:', error);
    }
  });

/**
 * 사용자 계정 삭제 시 모든 데이터 삭제
 */
export const onUserDeleted = functions.auth.user().onDelete(async (user) => {
  const uid = user.uid;
  const batch = db.batch();

  // 사용자 프로필 삭제
  batch.delete(db.doc(`users/${uid}`));

  // 정원 상태 삭제
  batch.delete(db.doc(`garden/${uid}/state`));

  // 엔트리, 예산, 구매 등은 별도 배치로 처리
  const collections = ['entries', 'budgets', 'purchases', 'tickets'];

  for (const collection of collections) {
    const snapshot = await db.collection(collection).doc(uid).listCollections();
    for (const subcollection of snapshot) {
      const docs = await subcollection.get();
      docs.forEach(doc => batch.delete(doc.ref));
    }
  }

  await batch.commit();
  console.log(`All data deleted for user ${uid}`);
});

/**
 * 매일 밤 리마인더 알림 전송
 */
export const sendDailyReminders = functions.pubsub
  .schedule('0 21 * * *')
  .timeZone('Asia/Ho_Chi_Minh')
  .onRun(async () => {
    // 알림 활성화된 사용자 조회
    const usersSnapshot = await db.collection('users')
      .where('notificationsEnabled', '==', true)
      .get();

    const tokens: string[] = [];

    usersSnapshot.forEach(doc => {
      const user = doc.data();
      if (user.fcmToken) {
        tokens.push(user.fcmToken);
      }
    });

    if (tokens.length === 0) {
      console.log('No users with FCM tokens');
      return;
    }

    const message = {
      notification: {
        title: '오늘의 씨앗을 심을 시간이에요 🌱',
        body: '하루를 마무리하며 오늘의 지출을 기록해보세요',
      },
      data: {
        screen: 'add_entry',
      },
      tokens: tokens,
    };

    try {
      const response = await admin.messaging().sendMulticast(message);
      console.log(`Sent ${response.successCount} reminders, ${response.failureCount} failures`);
    } catch (error) {
      console.error('Failed to send reminders:', error);
    }
  });