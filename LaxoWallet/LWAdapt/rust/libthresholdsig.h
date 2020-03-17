#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

char *add_transaction_change(const char *id, const char *script);

char *add_transaction_input(const char *id,
                            const char *txid,
                            uint8_t vout,
                            const char *script,
                            int64_t amount);

char *add_transaction_output(const char *id, const char *script, int64_t amount);

char *add_transaction_sig(const char *id,
                          uint8_t n_input,
                          const char *pubkey,
                          const char *r,
                          const char *s);

char *address_to_script(const char *addr);

char *combine_shares(const char *shares);

char *create_key(const char *pk,
                 uint8_t party_num,
                 uint8_t count,
                 uint8_t threshold,
                 const char *p,
                 const char *q);

char *create_multi_key(uint8_t ordinal, const char *secret, uint8_t count, uint8_t threshold);

char *create_multi_sign(const char *share_key,
                        uint8_t party_num,
                        const char *signers,
                        uint8_t threshold,
                        const char *message_hash);

char *create_party_key(const char *secret, const char *p, const char *q, uint8_t index);

char *create_sign(const char *share_key,
                  uint8_t party_num,
                  const char *vss,
                  const char *signers,
                  uint8_t count,
                  uint8_t threshold,
                  const char *eks,
                  const char *p,
                  const char *q,
                  const char *message_hash);

char *create_transaction(void);

char *derive_key(const char *phrase, const char *path);

char *destroy_key(const char *key);

char *destroy_multi_key(const char *key);

char *destroy_multi_sign(const char *key);

char *destroy_sign(const char *key);

char *destroy_transaction(const char *id);

char *get_delta_and_sigma(const char *key,
                          const char *alpha,
                          const char *beta,
                          const char *miu,
                          const char *ni);

char *get_encryption_key(const char *p, const char *q);

char *get_group_pubkey(const char *points);

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

char *get_message_sig(const char *message, const char *private_key);

char *get_party_shares(const char *secret,
                       uint8_t index,
                       const char *params,
                       const char *decom,
                       const char *bc);

char *get_public_key(const char *privkey);

char *get_public_point(const char *pubkey);

char *get_random_key_pair(void);

char *get_seed(void);

char *get_shared_secret(const char *pubkey, const char *privkey);

char *get_shares(const char *seed, uint8_t count, uint8_t threshold);

char *get_transaction_fee(const char *id);

char *get_transaction_sighash(const char *id);

char *get_xpub(const char *phrase);

char *hex2str(const char *hex_str);

char *key_handle_round1(const char *key, const char *data);

char *key_handle_round2(const char *key, const char *data1, const char *data2);

char *key_handle_round3(const char *key, const char *data);

char *multi_key_handle_round(const char *key, uint8_t round, const char *data);

char *multi_sign_handle_round(const char *key, uint8_t round, const char *data);

char *party_verify_vss(uint8_t index,
                       const char *params,
                       const char *y_vec,
                       const char *party_shares,
                       const char *vss_scheme);

char *reconstruct(const char *indices, const char *shares);

char *reconstruct_delta(const char *delta);

char *set_transaction_feerate(const char *id, uint16_t fee);

char *sha256(const char *message_hex);

char *sign_data(const char *data);

char *sign_handle_round(const char *key, uint8_t round, const char *data);

char *str2hex(const char *str);

char *sum_point(const char *y);

char *sum_scalar(const char *y);

char *transaction_to_json(const char *id);

char *update_commitments_to_xi(const char *com,
                               const char *vss_scheme,
                               uint8_t index,
                               const char *s);

char *verify_dlog_proofs(const char *params, const char *dlog_proof, const char *y_vec);

char *verify_proofs_get_alpha(const char *p, const char *q, const char *k_i, const char *m_b);

char *verify_sig(const char *message_hash, const char *pubkey, const char *r, const char *s);
