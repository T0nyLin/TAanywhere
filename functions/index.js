/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.verifyOTPCallable = functions.https.onCall(async (data, context) => {
  const { email, otp } = data;

  try {
    // Retrieve the user document from Firestore
    const userSnapshot = await admin.firestore().collection('users').doc(email).get();

    // Check if the user exists
    if (!userSnapshot.exists) {
      throw new functions.https.HttpsError('not-found', 'User not found');
    }

    // Get the user data
    const userData = userSnapshot.data();

    // Compare the entered OTP with the stored OTP
    if (otp !== userData.otp) {
      throw new functions.https.HttpsError('invalid-argument', 'Invalid OTP');
    }

    // Update the user document to mark OTP as verified
    await userSnapshot.ref.update({ otpVerified: true });

    // Return the verification result
    return {
      isVerified: true,
    };
  } catch (error) {
    console.error('Error verifying OTP:', error);
    throw new functions.https.HttpsError('internal', 'OTP verification failed');
  }
});

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
