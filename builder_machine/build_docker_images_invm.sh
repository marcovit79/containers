BUILD_DIR=$1
ACTION=$2

echo "${ACTION}"

cat "${BUILD_DIR}/build-order.txt" | grep -v -E "^#" | \
(
	while IFS='' read -r line || [ -n "$line" ]; do

		name=$( echo $line | sed -e 's/ .*//' )
		path=$( echo $line | sed -e 's/.* //' )
		echo "${ACTION} image $name from path $path"
		
		if ( [ "x${ACTION}" = "xbuild" ] ) then
			docker build --rm -t $name "${BUILD_DIR}/${path}"
			docker push $name
		fi
	done 
)
