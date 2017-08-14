SCRIPT_PATH="`dirname $(readlink -f $0)`"
TEST_PATH="`pwd`"
. $SCRIPT_PATH/config.sh

echo $TRANSMART_SCRIPT
echo $SCRIPT_PATH
echo $TEST_PATH
