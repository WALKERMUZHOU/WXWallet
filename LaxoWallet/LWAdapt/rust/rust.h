#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

//secret getinitdata返回

char *create_party_key(const char *secret, const char *p, const char *q, uint8_t index);

char *create_sign_key(const char *ek,
                      uint8_t index,
                      const char *shared_keys,
                      const char *vss,
                      const char *signers_vec);

char *get_delta_and_sigma(const char *key,
                          const char *alpha,
                          const char *beta,
                          const char *miu,
                          const char *ni);

//ek
char *get_encryption_key(const char *p, const char *q);

char *get_local_sig(const char *key,
                    const char *g_gamma_i,
                    const char *delta_inv,
                    const char *b_proof,
                    const char *decommit,
                    const char *bc1,
                    const char *sigma_i,
                    const char *y,
                    const char *message_str);

char *get_message_b(const char *g, const char *paillier_key, const char *m_a);

char *get_party_shares(const char *secret,
                       uint8_t index,
                       const char *params,
                       const char *decom,
                       const char *bc);

//返回p and q
char *get_random_key_pair(void);

char *party_verify_vss(uint8_t index,
                       const char *params,
                       const char *y_vec,
                       const char *party_shares,
                       const char *vss_scheme);

char *reconstruct(const char *indices, const char *shares);

char *reconstruct_delta(const char *delta);

char *rust_hello(const char *to);

char *sum_point(const char *y);

char *sum_scalar(const char *y);

char *update_commitments_to_xi(const char *com,
                               const char *vss_scheme,
                               uint8_t index,
                               const char *s);

char *verify_dlog_proofs(const char *params, const char *dlog_proof, const char *y_vec);

char *verify_proofs_get_alpha(const char *p, const char *q, const char *k_i, const char *m_b);
