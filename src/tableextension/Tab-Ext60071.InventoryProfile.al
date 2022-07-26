tableextension 60071 "PWD InventoryProfile" extends "Inventory Profile"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_PROD01.001: TO 13/12/2011:  No Commande vente identique OF-LOT
    //                                           - Add fields 50000..50004
    // 
    // 
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50000; "PWD Original Source Id"; Integer)
        {
            Caption = 'Original Source Id';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50001; "PWD Original Source No."; Code[20])
        {
            Caption = 'Original Source No.';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50002; "PWD Original Source Position"; Integer)
        {
            Caption = 'Original Source Position';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50003; "PWD Original Counter"; Integer)
        {
            Caption = 'Original Counter';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
        field(50004; "PWD Transmitted Order No."; Boolean)
        {
            Caption = 'Transmitted Order No.';
            Description = 'LAP1.00';
            DataClassification = CustomerContent;
        }
    }
    PROCEDURE Fct_TransmitOrderNo(CodPItemNo: Code[20]) BooLTransOrderNo: Boolean
    VAR
        Item: Record Item;
        ItemCategory: Record "Item Category";
    BEGIN
        BooLTransOrderNo := FALSE;

        IF Item.GET(CodPItemNo) THEN
            IF ItemCategory.GET(Item."Item Category Code") THEN
                IF ItemCategory."PWD Transmitted Order No." THEN
                    BooLTransOrderNo := TRUE;
    END;

}
