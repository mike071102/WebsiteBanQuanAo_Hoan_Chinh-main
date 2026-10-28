package poly.java.Service;

import vn.payos.PayOS;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkRequest;
import vn.payos.model.v2.paymentRequests.CreatePaymentLinkResponse;

import java.nio.charset.StandardCharsets;

public class PayOSService {

    public static final String CLIENT_ID = "46f26307-6c63-4d8c-b1d3-d3426a5eca14";
    public static final String API_KEY = "2030bc2b-fec1-4500-a902-87cfae8e2fbe";
    public static final String CHECKSUM_KEY = "23e4ce966e400ccffffa570a9ea7784effec01006bb196622058e8a29b1e9de0";

    public static final String BANK_NUMBER = "31780007119999";
    public static final String BANK_NAME = "NGUYEN LE MINH NHUT";
    public static final String BANK_BIN = "970422";

    private static PayOS payOS;

    static {
        try {
            payOS = new PayOS(CLIENT_ID, API_KEY, CHECKSUM_KEY);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static class PayOSResult {
        private final boolean success;
        private final String checkoutUrl;
        private final String qrCode;
        private final String rawResponse;

        public PayOSResult(boolean success, String checkoutUrl, String qrCode, String rawResponse) {
            this.success = success;
            this.checkoutUrl = checkoutUrl;
            this.qrCode = qrCode;
            this.rawResponse = rawResponse;
        }

        public boolean isSuccess() {
            return success;
        }

        public String getCheckoutUrl() {
            return checkoutUrl;
        }

        public String getQrCode() {
            return qrCode;
        }

        public String getRawResponse() {
            return rawResponse;
        }
    }

    public static PayOSResult createPaymentLink(long orderCode, int amount, String description, String returnUrl, String cancelUrl) {
        try {
            String desc = description;
            if (desc != null) {
                desc = java.text.Normalizer.normalize(desc, java.text.Normalizer.Form.NFD)
                        .replaceAll("\\p{M}", "")
                        .replaceAll("[^a-zA-Z0-9 ]", "");
                if (desc.length() > 25) {
                    desc = desc.substring(0, 25);
                }
            }

            if (payOS != null) {
                CreatePaymentLinkRequest request = CreatePaymentLinkRequest.builder()
                        .orderCode(orderCode)
                        .amount((long) amount)
                        .description(desc)
                        .returnUrl(returnUrl)
                        .cancelUrl(cancelUrl)
                        .build();

                CreatePaymentLinkResponse response = payOS.paymentRequests().create(request);
                if (response != null && response.getCheckoutUrl() != null && !response.getCheckoutUrl().isBlank()) {
                    return new PayOSResult(true, response.getCheckoutUrl(), response.getQrCode(), "SUCCESS");
                }
            }
        } catch (Exception e) {
            System.err.println("PayOS Service Error: " + e.getMessage());
            e.printStackTrace();
        }

        // Fallback to VietQR
        String vietQrUrl = String.format("https://img.vietqr.io/image/MB-%s-compact2.png?amount=%d&addInfo=%s&accountName=%s",
                BANK_NUMBER, amount, java.net.URLEncoder.encode(description, StandardCharsets.UTF_8),
                java.net.URLEncoder.encode(BANK_NAME, StandardCharsets.UTF_8));
        return new PayOSResult(false, vietQrUrl, vietQrUrl, "FALLBACK_VIETQR");
    }
}
