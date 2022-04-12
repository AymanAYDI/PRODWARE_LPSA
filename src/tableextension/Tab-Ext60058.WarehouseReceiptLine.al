tableextension 60058 "PWD WarehouseReceiptLine" extends "Warehouse Receipt Line"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP1.00
    // FE_LAPIERRETTE_ART02.001: NI 23/11/2011:  Désignation article 120 caracteres
    //                                           - Add field 50004..50005
    //                                           - Add C/AL in trigger "Description - OnValidate"
    //                                                                 "Description 2 - OnValidate"
    //                                                                 "LPSA Description 1 - OnValidate"
    //                                                                 "LPSA Description 2 - OnValidate"
    // 
    // ------------------------------------------------------------------------------------------------------------------
    fields
    {
        field(50004; "PWD LPSA Description 1"; Text[120])
        {
            Caption = 'LPSA Description 1';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_ART02.001
                IF STRLEN("PWD LPSA Description 1") > 50 THEN
                    Description := PADSTR("PWD LPSA Description 1", 50)
                ELSE
                    Description := "PWD LPSA Description 1";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
        field(50005; "PWD LPSA Description 2"; Text[120])
        {
            Caption = 'LPSA Description 2';
            Description = 'LAP1.00';

            trigger OnValidate()
            begin
                //>>FE_LAPIERRETTE_ART02.001
                IF STRLEN("PWD LPSA Description 2") > 50 THEN
                    "Description 2" := PADSTR("PWD LPSA Description 2", 50)
                ELSE
                    "Description 2" := "PWD LPSA Description 2";
                //<<FE_LAPIERRETTE_ART02.001
            end;
        }
    }
}

