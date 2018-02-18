#include <assert.h>
#include <stdio.h>
#include <string.h>

#include "clhash.h"

int main() {
    void * random =  get_random_key_for_clhash(UINT64_C(0x23a23cf5033c3c81),UINT64_C(0xb3816f6a2c68e530));
    /* void * random =  get_random_key_for_clhash(137, 777); */
    uint64_t hashvalue1 = clhash(random,"my dog",6);
    uint64_t hashvalue2 = clhash(random,"my cat",6);
    uint64_t hashvalue3 = clhash(random,"my dog",6);
    assert(hashvalue1 == hashvalue3);
    assert(hashvalue1 != hashvalue2);// very likely to be true
    printf("%llu, %zu\n", hashvalue1, sizeof(hashvalue1));
    free(random);

    // API 2
    void *rand = clhash_init();
    char *txt = "enum {RANDOM_64BITWORDS_NEEDED_FOR_CLHASH=133,RANDOM_BYTES_NEEDED_FOR_CLHASH=133*8};";
    uint64_t hv1 = clhash(rand, txt, strlen(txt));
    printf("%llu\n", hv1);
    free(rand);

    return 0;
}
