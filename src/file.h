#pragma once

#include <iostream>
#include <fstream>
#include <vector>

void fill_byte_buffer(std::vector<char> *payload, std::ifstream *file) {
    if (!file->eof() && !file->fail()) {
        file->seekg(0, std::ios_base::end);
        std::streampos fileSize = file->tellg();
        payload->resize(fileSize);

        file->seekg(0, std::ios_base::beg);
        file->read(&payload->front(), fileSize);
    }
}
