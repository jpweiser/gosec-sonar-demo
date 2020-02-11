package vuln

import "crypto/md5"


func badCrypto(){

	x := 0
	y := 2
    if x > y {
        md5.New()
    }

}