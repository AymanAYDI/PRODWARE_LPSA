pageextension 60045 "PWD InventorySetup" extends "Inventory Setup"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare                                                                                                       |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.12
    // P19646_010 : RO : 20/06/2017 :  CONFIGURATEUR ARTICLES
    //                - Add Tab Item Configurator with Fields Product Group Code  Dimension
    //                                                        LPSA Customer No.
    //                                                        STRATEGY Customer No.
    //                                                        Item Filter For Extern Ref
    // 
    // //>>LAP2.19
    // P24578_008.001 : LY 12/08/2019 : Export contrôle de gestion
    layout
    {
        addafter(Dimensions)
        {
            group("PWD Control1100267002")
            {
                field("PWD Item Category Dimension"; "PWD Item Category Dimension")
                {
                    ApplicationArea = All;
                }
                field("PWD Product Group Dimension"; "PWD Product Group Dimension")
                {
                    ApplicationArea = All;
                }
            }
        }
        addafter(Numbering)
        {
            group("PWD Specific")
            {
                Caption = 'Specific';
                field("PWD Item Filter Level 1"; "PWD Item Filter Level 1")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter Level 2"; "PWD Item Filter Level 2")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter Level 3"; "PWD Item Filter Level 3")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter Level 4"; "PWD Item Filter Level 4")
                {
                    ApplicationArea = All;
                }
                group("PWD Export Closing File")
                {
                    Caption = 'Export Closing File';
                    field("PWD Closing Export DateFormula"; "PWD Closing Export DateFormula")
                    {
                        ApplicationArea = All;
                    }
                    field("PWD Period for Inventory Cover"; "PWD Period for Inventory Cover")
                    {
                        ApplicationArea = All;
                    }
                    field("PWD Path for Closing Export"; "PWD Path for Closing Export")
                    {
                        ApplicationArea = All;

                        trigger OnAssistEdit()
                        var
                            CduLCommonDialogMgt: Codeunit "SMTP Test Mail";
                            CstL50000: Label 'Open';
                            CstL50001: Label 'File';
                            CstL50002: Label 'File path too long, you should change of location.';
                            TxtLDirectoryPath: Text[250];
                        begin
                            //>>P24578_008.001
                            CLEAR(CduLCommonDialogMgt);
                            CLEAR(TxtLDirectoryPath);
                            //TODO: Codeunit "SMTP Test Mail" does not contain a definition for 'OpenFile'
                            //TxtLDirectoryPath := CduLCommonDialogMgt.OpenFile(CstL50000, "PWD Path for Closing Export" + CstL50001, 1, '', 2);
                            IF STRLEN(TxtLDirectoryPath) > MAXSTRLEN("PWD Path for Closing Export") THEN
                                ERROR(CstL50002)
                            ELSE
                                VALIDATE("PWD Path for Closing Export", TxtLDirectoryPath);
                            //<<P24578_008.001
                        end;
                    }
                    field("PWD Closing Sendor E-Mail"; "PWD Closing Sendor E-Mail")
                    {
                        ApplicationArea = All;
                    }
                    field("PWD Recipient User ID"; "PWD Recipient User ID")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group("PWD Item Configurator")
            {
                Caption = 'Item Configurator';
                field("PWD Product Group Code  Dimension"; "PWD Product Group Code Dim")
                {
                    ApplicationArea = All;
                }
                field("PWD LPSA Customer No."; "PWD LPSA Customer No.")
                {
                    ApplicationArea = All;
                }
                field("PWD STRATEGY Customer No."; "PWD STRATEGY Customer No.")
                {
                    ApplicationArea = All;
                }
                field("PWD Item Filter For Extern Ref"; "PWD Item Filter For Extern Ref")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}

