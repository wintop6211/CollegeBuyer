package main.java.notification;

import com.turo.pushy.apns.ApnsClient;
import com.turo.pushy.apns.ApnsClientBuilder;
import com.turo.pushy.apns.PushNotificationResponse;
import com.turo.pushy.apns.auth.ApnsSigningKey;
import com.turo.pushy.apns.util.ApnsPayloadBuilder;
import com.turo.pushy.apns.util.SimpleApnsPushNotification;
import io.netty.util.concurrent.Future;
import main.java.services.helpers.PathManager;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.concurrent.ExecutionException;

/**
 * The class for managing APN connections. APN is used for sending notifications to iOS devices.
 */
public class APNConnector {

    private ApnsClient client;
    private static String TEAM_ID = "";
    private static String KEY_ID = "";

    /**
     * Creates the APN client object
     *
     * @throws InvalidKeyException      The signed key is invalid
     * @throws NoSuchAlgorithmException if the JVM does not support elliptic curve keys
     * @throws IOException              if the key file cannot be found
     */
    private APNConnector() throws InvalidKeyException, NoSuchAlgorithmException, IOException {
        this.client = new ApnsClientBuilder()
                .setSigningKey(ApnsSigningKey.loadFromPkcs8File(
                        new File(PathManager.getAPNKeyAddress()),
                        TEAM_ID, KEY_ID)).setApnsServer(ApnsClientBuilder.DEVELOPMENT_APNS_HOST
                )
                .build();
    }

    /**
     * Sends the purchase request notification
     *
     * @param deviceToken The unique id which represents the target device
     * @param seller      The name of the seller
     * @throws ExecutionException   if the computation threw an exception
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    public void sendPurchaseRequestNotification(String deviceToken, String seller) throws ExecutionException, InterruptedException {
        if (deviceToken != null) {
            String title = "Purchase Request";
            String body = "The purchase request from " + seller;
            sendNotification(deviceToken, title, body);
        }
    }

    /**
     * Sends the notification which reports that the request has been confirmed
     *
     * @param deviceToken The unique id which represents the target device
     * @param seller      The name of the seller
     * @param product     The purchased product
     * @throws ExecutionException   if the computation threw an exception
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    public void sendConfirmRequestNotification(String deviceToken, String seller, String product) throws ExecutionException, InterruptedException {
        if (deviceToken != null) {
            String title = "Request confirmed";
            String body = product + " has confirmed by " + seller;
            sendNotification(deviceToken, title, body);
        }
    }

    /**
     * Sends the notification which reports that the request is canceled
     *
     * @param deviceToken The unique id which represents the target device
     * @param buyer       The name of the buyer
     * @param product     The product which needs to be canceled
     * @throws ExecutionException   if the computation threw an exception
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    public void sendCancelRequestNotification(String deviceToken, String buyer, String product) throws ExecutionException, InterruptedException {
        if (deviceToken != null) {
            String title = "Request Canceled";
            String body = buyer + " canceled request for " + product;
            sendNotification(deviceToken, title, body);
        }
    }

    /**
     * Close the connection with APN. Make sure to call this method to release memories.
     *
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    public void closeConnection() throws InterruptedException {

        Future<Void> closeFuture = client.close();
        closeFuture.await();
    }

    /**
     * Gets the APN connection from the session
     *
     * @param request The object which contains the request information
     * @return The APN connector object
     * @throws InvalidKeyException      if the signed key is invalid
     * @throws NoSuchAlgorithmException if the JVM does not support elliptic curve keys
     * @throws IOException              if the key file cannot be found
     */
    public static APNConnector getAPNConnectorFromSession(HttpServletRequest request) throws
            InvalidKeyException, NoSuchAlgorithmException, IOException {
        HttpSession httpSession = request.getSession(false);
        APNConnector connector;
        if (httpSession != null) {
            connector = (APNConnector) httpSession.getAttribute("APNConnection");
        } else {
            httpSession = request.getSession();
            connector = new APNConnector();
            httpSession.setMaxInactiveInterval(3600 * 24);
            httpSession.setAttribute("APNConnection", connector);
        }
        return connector;
    }

    /**
     * The helper method for sending the notification
     *
     * @param deviceToken The unique id which represents the target device
     * @param title       The title of the notification
     * @param body        The body of the notification
     * @throws ExecutionException   if the computation threw an exception
     * @throws InterruptedException if the current thread was interrupted while waiting
     */
    private void sendNotification(String deviceToken, String title, String body) throws ExecutionException, InterruptedException {
        ApnsPayloadBuilder payloadBuilder = new ApnsPayloadBuilder();
        payloadBuilder.setAlertTitle(title);
        payloadBuilder.setAlertBody(body);
        String payload = payloadBuilder.buildWithDefaultMaximumLength();
        SimpleApnsPushNotification pushNotification = new SimpleApnsPushNotification(deviceToken, "com.ColleNet.CollegeBuyer", payload);
        Future<PushNotificationResponse<SimpleApnsPushNotification>> sendNotificationFuture = client.sendNotification(pushNotification);
        sendNotificationFuture.get();
    }
}
