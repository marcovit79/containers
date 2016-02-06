BUILD_DIR=$1

# TODO: login to docker registry (if needed)
if ( [ ! -r "${HOME}/.docker/config.json" ] ) then
	docker login
fi

cat "${BUILD_DIR}/build-order.txt" | grep -v -E "^#" | \
(
	while IFS='' read -r line || [ -n "$line" ]; do

		name=$( echo $line | sed -e 's/ .*//' )
		path=$( echo $line | sed -e 's/.* //' )
		
		if ( [ "x" != "x${name}" ] ) then
			echo "Image $name from path ${BUILD_DIR}/$path"
			
			if ( [ -r "${BUILD_DIR}/${path}/builds/build-all.sh" ] ) then
				echo "Build prerequisites"
				( cd "${BUILD_DIR}/${path}/builds/" && sh build-all.sh )
			fi

			echo "Build and push $path"
			docker build --rm -t $name "${BUILD_DIR}/${path}"
			docker push $name
		fi
	done 
)
