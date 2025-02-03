*** Settings ***
Library           Browser   run_on_failure=Take Screenshot \ EMBED
Library           Collections
Library           DateTime
Library           String
Library           OperatingSystem
Library           DebugLibrary

*** Test Cases ***
Test case to verify shopping mall functionality
    # Open a new browser instance
    New Browser    chromium    headless=false
    # Open a new browser context with geolocation permissions
    New Context    permissions=["geolocation"]
    # Open the specified URL
    New Page    https://www.central.co.th/th
    # Set the selector prefix for the modal message iframe
    Set Selector Prefix    //iframe[@title="Modal Message"] >>>    Test
    # Click the close button on the modal
    Click    //div[@class="bz-modal"]//button[@class="bz-close-btn"] >> nth=0
    # Reset the selector prefix
    Set Selector Prefix    ${NONE}
    # Scroll to the first product carousel title
    Scroll To Element    (//h2[@class="product-carousel__title"])[1]
    # Click the first product in the carousel
    Click    (//a[contains(@data-testid,"lnk-viewProduct-productCarousal")])[1]
    # Wait for the add to cart button to be in the desired state
    Wait For Elements State    //button[contains(@data-testid,"btn-addCart-produc")]
    # Click the add to cart button
    Click    //button[contains(@data-testid,"btn-addCart-produc")]
    # Get the product name
    ${product_name}    Get Text    //div[contains(@class,"productDetail")]//a[contains(@data-testid,"lnk-viewProduct-brand")]
    # Get the product description
    ${product_desc}    Get Text    //div[contains(@class,"productDetail")]//div[@class="pdp-productDetail__desc"]
    # Convert the product description to lowercase
    ${to_lowercase_product_desc}=	Convert To Lower Case    ${product_desc}
    # Convert the product description to title case
    ${to_title_case_product_desc}=	Convert To Title Case    ${to_lowercase_product_desc}
    # Get the selling price of the product
    ${price_sell}    Get Text    //div[contains(@class,"productDetail")]//div[contains(@class,"priceSell")]
    # Get the saved price of the product
    ${price_save}    Get Text    //div[contains(@class,"productDetail")]//div[contains(@class,"priceSave")]
    # Wait for the cart icon to show the correct number of items
    Wait For Condition    Text    //a[@data-testid="btn-viewCart-bag"]/following-sibling::span    should be     1    timeout=3 s
    # Click the cart icon to view the cart
    Click    //a[@data-testid="btn-viewCart-bag"]
    # Verify the product name in the cart
    Get Text    //section[@class="spc-product-card"]//a[contains(@data-testid,"lnk-viewCart-brand")]    should be     ${product_name}
    # Verify the product description in the cart
    Get Text    //section[@class="spc-product-card"]//a[contains(@data-testid,"lnk-viewCart-itemCDS")]    contains     ${to_title_case_product_desc}
    # Verify the selling price in the cart
    Get Text    //section[@class="spc-product-card"]//div[contains(@class,"card-price-special")]    should be     ${price_sell}
    # Verify the saved price in the cart
    Get Text    //section[@class="spc-product-card"]//span[contains(@class,"deleted-price")]    should start with     ${price_save}
    # Scroll to the pricing section
    Scroll To Element    //section[@class="spc-product-pricing"]
    # Verify the element states in the pricing section
    Get Element States    //section[@class="spc-product-pricing"]//div//div[text()="ยอดรวม (1 รายการ)"]    contains     attached    visible    enabled
    # Get the total pricing order
    ${pricing_order_total}    Get Text    //section[@class="spc-product-pricing"]//div[contains(@class,"pricing__order-total")]
    # Clean the amount by removing newline characters
    ${cleaned_amount}=    Replace String    ${pricing_order_total}    \n    ${EMPTY}
    # Verify the cleaned amount matches the selling price
    Should Be Equal    ${cleaned_amount}    ${price_sell}
    # Get the grand total amount
    ${grand_total}    Get Text    //div[@id="spcCheckoutBtnFooter"]//span[@id="spcBagGrandTotal"]
    # Remove the currency symbol from the cleaned amount
    ${amount}=    Replace String    ${cleaned_amount}    ฿    ${EMPTY}
    # Verify the amount matches the grand total
    Should Be Equal    ${amount}    ${grand_total}
    # Take a screenshot of the final state
    Take Screenshot    EMBED