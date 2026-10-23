/** Call before any TLS connection or SSLContext initialization. */
public final class TruststoreBootstrap {
  private TruststoreBootstrap() {}
  public static void configure() {
    String password = System.getenv("JAVA_TRUSTSTORE_PASSWORD");
    if (password == null || password.isBlank()) {
      throw new IllegalStateException("Missing JAVA_TRUSTSTORE_PASSWORD");
    }
    System.setProperty("javax.net.ssl.trustStorePassword", password);
  }
}
