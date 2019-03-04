#!/bin/bash

TEMPLATE_DIR="/home/milanbojovic/bash_scripts/create_invoice/TEMPLATE/"
TEMPLATE_NAME="WORK_ORDER_TEMPLATE.docx"
DIRECTORY=${TEMPLATE_NAME%".docx"}
TARGET_FILE_NAME=$DIRECTORY/word/document.xml

DAY=`date +%d`
MONTH=`date +%m`
YEAR=`date +%Y`
FDMY=01.$MONTH.$YEAR.
LDMY=`date -d "$(($MONTH%12+1))/1 - 1 days" +%d`
AMOUNT=0,000.00

echo "TARGET_FILE_NAME=$TARGET_FILE_NAME"


echo "Copying template: "
cp "$TEMPLATE_DIR/$TEMPLATE_NAME" .

echo "Unzipping template: "
unzip $TEMPLATE_NAME -d $DIRECTORY

echo "Removing src file"
rm $TEMPLATE_NAME

echo "Replacing placeholder values"
sed -i "s/FDMY/$FDMY/" $TARGET_FILE_NAME
sed -i "s/FDMY/$FDMY/" $TARGET_FILE_NAME
sed -i "s/LDMY/$LDMY.$MONTH.$YEAR./" $TARGET_FILE_NAME
sed -i "s/LDMY/$LDMY.$MONTH.$YEAR./" $TARGET_FILE_NAME
sed -i "s/LDMY/$LDMY.$MONTH.$YEAR./" $TARGET_FILE_NAME
sed -i "s/AMOUNT/$AMOUNT/" $TARGET_FILE_NAME

echo "Compressing template - creating word file"
cd $DIRECTORY
zip -r $TEMPLATE_NAME *
mv $TEMPLATE_NAME ../${TEMPLATE_NAME%"_TEMPLATE.docx"}_"$MONTH"_$YEAR.docx
cd ..
rm -r $DIRECTORY


echo "LDMY=$LDMY"
echo "MONTH=$MONTH"
