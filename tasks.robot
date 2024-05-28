*** Settings ***
Documentation
...                 The goal of this project is to develop a web automation tool capable of performing various tasks on an e-commerce website.
...                 The automation process includes logging into the website, searching for products based on user input,
...                 adding selected products to the shopping cart, and simulating the checkout process.

Library             RPA.Browser.Selenium
Library             DOP.RPA.Log
Library             DOP.RPA.Asset
Library             DOP.RPA.ProcessArgument
Library             RPA.Excel.Files
Library             Collections
Library             ConvertString
Library             CheckStatusCode
Library             String
Library             RPA.Windows
Library             RPA.HTTP
Library             RPA.JSON
Library             DateTime

*** Variables ***
${global_product_info}      ${EMPTY}

${EXCEL_FILE_NAME}          data_magento.xlsx
${DIRECTORY_PATH}           ${CURDIR}


*** Tasks ***
Automated E-commerce Shopping
    Convert Infomation Of Product To Excel File
    Close All Browsers


*** Keywords ***
Convert Infomation Of Product To Excel File
    [Documentation]    Converts the information from a JSON file to an Excel file.
    ...                This keyword takes a JSON file as input, reads the data,
    ...                and writes the information to a specified Excel file.

    ${product_info}=    Get In Arg    file_input
    ${product_info_value}=    Set Variable    ${product_info}[value]
    ${product_json}    Load JSON From File    ${product_info_value}

    Create File Excel Data
    FOR    ${product}    IN    @{product_json}
        Save Infomation By Excel Files
        ...    ${product}
    END
    Save Workbook

    ${file_path}=    Catenate    SEPARATOR=    ${DIRECTORY_PATH}    /    ${EXCEL_FILE_NAME}
    Set Out Arg    file_output    ${file_path}

Create File Excel Data
    [Documentation]    Creates a new Excel file to store product information and order numbers

    Create Workbook    data_magento.xlsx
    Set Worksheet Value    1    1    Name
    Set Worksheet Value    1    2    Quantity
    Set Worksheet Value    1    3    Price
    Set Worksheet Value    1    4    Order Number
    Set Worksheet Value    1    5    Size
    Set Worksheet Value    1    6    Color
    Set Worksheet Value    1    7    Time

Save Infomation By Excel Files
    [Documentation]    Saves the information of each product along with the order number, color, and size into the Excel file
    [Arguments]    ${product}

    ${row}=    Create Dictionary
    ...    Name=${product['name_product']}
    ...    Price=${product['price_product']}
    ...    Quantity=${product['quantity_product']}
    ...    Order Number=${product['order_number']}
    ...    Size=${product['size']}
    ...    Color=${product['color']}
    ...    Time=${product['current_time']}
    Append Rows To Worksheet    ${row}    header=True
