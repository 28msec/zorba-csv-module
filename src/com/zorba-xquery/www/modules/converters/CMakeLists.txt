# Copyright 2006-2008 The FLWOR Foundation.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# csv
DECLARE_ZORBA_SCHEMA (FILE csv-options.xsd
  URI "http://www.zorba-xquery.com/modules/converters/csv-options")
DECLARE_ZORBA_MODULE (URI "http://www.zorba-xquery.com/modules/converters/csv" VERSION 1.0 FILE "csv.xq")

# add unit test for streambuf implementation in csv, related to streamable strings
CREATE_TEST_SOURCELIST (
  StreambufUnitTests
  StreambufUnitTests.cpp
  streambuftest.cpp
)
ADD_EXECUTABLE (StreambufUnitTests ${StreambufUnitTests} csv.xq.src/stringiterator_streambuf.cpp)
SET_TARGET_PROPERTIES (StreambufUnitTests PROPERTIES
  FOLDER "Tests"
)

ADD_TEST ("streamable_string_streambuf" StreambufUnitTests "streambuftest")
ADD_TEST_DIRECTORY("${PROJECT_SOURCE_DIR}/test")

