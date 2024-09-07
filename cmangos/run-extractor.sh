#!/bin/bash
set -e

EXTRACTOR_DIR=/extractor
CLIENT_DIR=${EXTRACTOR_DIR}/client
RESOURCES_DIR=${EXTRACTOR_DIR}/resources
TOOLS_DIR=/opt/cmangos/bin/tools

extractor_files="
    ad
    ExtractResources.sh
    MoveMapGen
    MoveMapGen.sh
    offmesh.txt
    vmap_assembler
    vmap_extractor
"

echo "Copying extractor tools to client dir..."
for extractor_file in ${extractor_files}; do
    cp "${TOOLS_DIR}/${extractor_file}" "${CLIENT_DIR}"
done

cd ${CLIENT_DIR}
printf "y\n" | ./ExtractResources.sh

echo "Deleting extractor tools from client dir..."
for extractor_file in ${extractor_files}; do
    rm "${CLIENT_DIR}/${extractor_file}"
done

output_files="
    Buildings
    Cameras
    dbc
    MaNGOSExtractor_detailed.log
    MaNGOSExtractor.log
    maps
    mmaps
    vmaps
"

echo "Moving extractor output to resources dir..."
mkdir -p ${EXTRACTOR_DIR}/resources
for output_file in ${output_files}; do
    mv "${CLIENT_DIR}/${output_file}" "${RESOURCES_DIR}"
done

echo "Extraction done"
