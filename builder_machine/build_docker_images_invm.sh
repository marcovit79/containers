BUILD_DIR=$1

# TODO: login to docker registry (if needed)

cat "${BUILD_DIR}/build-order.txt" | grep -v -E "^#" | \
(
	while IFS='' read -r line || [ -n "$line" ]; do

		name=$( echo $line | sed -e 's/ .*//' )
		path=$( echo $line | sed -e 's/.* //' )
		echo "Image $name from path $path"
		
		docker build --rm -t $name "${BUILD_DIR}/${path}"
		docker push $name
	done 
)
