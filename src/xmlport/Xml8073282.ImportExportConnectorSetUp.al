xmlport 8073282 "Import Export Connector SetUp"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // FE_ProdConnect.001:GR 26/01/2011  Connector integration
    //                                   - Create Object

    Caption = 'Import Export Connector SetUp';

    schema
    {
        textelement(Partners_Connector)
        {
            tableelement("PWD Partner Connector"; "PWD Partner Connector")
            {
                XmlName = 'Partner_Connector';
                fieldattribute(Code; "PWD Partner Connector".Code)
                {
                }
                fieldelement(Name; "PWD Partner Connector".Name)
                {
                }
                fieldelement(Blocked; "PWD Partner Connector".Blocked)
                {
                }
                fieldelement(Receive_Queue; "PWD Partner Connector"."Receive Queue")
                {
                }
                fieldelement(Reply_Queue; "PWD Partner Connector"."Reply Queue")
                {
                }
                fieldelement(Data_Format; "PWD Partner Connector"."Data Format")
                {
                }
                fieldelement(Separator; "PWD Partner Connector".Separator)
                {
                }
                fieldelement(Object_ID_to_Run; "PWD Partner Connector"."Object ID to Run")
                {
                }
                fieldelement(Object_Name_to_Run; "PWD Partner Connector"."Object Name to Run")
                {
                }
                fieldelement(Communication_Mode; "PWD Partner Connector"."Communication Mode")
                {
                }
                fieldelement(Functions_CodeUnit_ID; "PWD Partner Connector"."Functions CodeUnit ID")
                {
                }
                fieldelement(Functions_CodeUnit_Name; "PWD Partner Connector"."Functions CodeUnit Name")
                {
                }
                fieldelement(Default_Value_Bool_Yes; "PWD Partner Connector"."Default Value Bool Yes")
                {
                }
                fieldelement(Default_Value_Bool_No; "PWD Partner Connector"."Default Value Bool No")
                {
                }
                textelement(Connectors_Messages)
                {
                    MinOccurs = Zero;
                    tableelement("PWD Connector Messages"; "PWD Connector Messages")
                    {
                        LinkFields = "Partner Code" = FIELD(Code);
                        LinkTable = "PWD Partner Connector";
                        MinOccurs = Zero;
                        XmlName = 'Connector_Messages';
                        SourceTableView = SORTING("Partner Code", Code, Direction);
                        fieldelement(Partner_Code; "PWD Connector Messages"."Partner Code")
                        {
                        }
                        fieldelement(Code; "PWD Connector Messages".Code)
                        {
                        }
                        fieldelement(Description; "PWD Connector Messages".Description)
                        {
                        }
                        fieldelement(Path; "PWD Connector Messages".Path)
                        {
                        }
                        fieldelement(Blocked; "PWD Connector Messages".Blocked)
                        {
                        }
                        fieldelement(Archive_Message; "PWD Connector Messages"."Archive Message")
                        {
                        }
                        fieldelement(Function; "PWD Connector Messages".Function)
                        {
                        }
                        fieldelement(Table_ID; "PWD Connector Messages"."Table ID")
                        {
                        }
                        fieldelement(Table_Name; "PWD Connector Messages"."Table Name")
                        {
                        }
                        fieldelement(Xml_Tag; "PWD Connector Messages"."Xml Tag")
                        {
                        }
                        fieldelement(Direction; "PWD Connector Messages".Direction)
                        {
                        }
                        fieldelement(Fill_Character; "PWD Connector Messages"."Fill Character")
                        {
                        }
                        fieldelement(Export_Date; "PWD Connector Messages"."Export Date")
                        {
                        }
                        fieldelement(Field_ID; "PWD Connector Messages"."Field ID")
                        {
                        }
                        fieldelement(Field_Name; "PWD Connector Messages"."Field Name")
                        {
                        }
                        fieldelement(Master_Table; "PWD Connector Messages"."Master Table")
                        {
                        }
                        fieldelement(Export_Option; "PWD Connector Messages"."Export Option")
                        {
                        }
                        fieldelement("Auto-Post_Document"; "PWD Connector Messages"."Auto-Post Document")
                        {
                        }
                        fieldelement(Archive_Path; "PWD Connector Messages"."Archive Path")
                        {
                        }
                        textelement(Fields_Exports_Setups)
                        {
                            MinOccurs = Zero;
                            tableelement("PWD Fields Export Setup"; "PWD Fields Export Setup")
                            {
                                LinkFields = "Partner Code" = FIELD("Partner Code"), "Message Code" = FIELD(Code);
                                LinkTable = "PWD Connector Messages";
                                LinkTableForceInsert = true;
                                MinOccurs = Zero;
                                XmlName = 'Fields_Export_Setup';
                                SourceTableView = SORTING("Partner Code", "Message Code", Direction, "Line No.");
                                fieldelement(Partner_Code; "PWD Fields Export Setup"."Partner Code")
                                {
                                }
                                fieldelement(Message_Code; "PWD Fields Export Setup"."Message Code")
                                {
                                }
                                fieldelement("Line_No."; "PWD Fields Export Setup"."Line No.")
                                {
                                }
                                fieldelement(Table_ID; "PWD Fields Export Setup"."Table ID")
                                {
                                }
                                fieldelement(Table_Name; "PWD Fields Export Setup"."Table Name")
                                {
                                }
                                fieldelement(Field_ID; "PWD Fields Export Setup"."Field ID")
                                {
                                }
                                fieldelement(Field_Name; "PWD Fields Export Setup"."Field Name")
                                {
                                }
                                fieldelement(Xml_Tag; "PWD Fields Export Setup"."Xml Tag")
                                {
                                }
                                fieldelement(File_Position; "PWD Fields Export Setup"."File Position")
                                {
                                }
                                fieldelement(File_Length; "PWD Fields Export Setup"."File Length")
                                {
                                }
                                fieldelement(Direction; "PWD Fields Export Setup".Direction)
                                {
                                }
                                fieldelement(Type; "PWD Fields Export Setup".Type)
                                {
                                }
                                fieldelement(FormatStr; "PWD Fields Export Setup".FormatStr)
                                {
                                }
                                fieldelement(Precision; "PWD Fields Export Setup".Precision)
                                {
                                }
                                fieldelement(Rounding_Direction; "PWD Fields Export Setup"."Rounding Direction")
                                {
                                }
                                fieldelement(Fill_up; "PWD Fields Export Setup"."Fill up")
                                {
                                }
                                fieldelement(Fill_Character; "PWD Fields Export Setup"."Fill Character")
                                {
                                }
                                fieldelement(Fct_For_Replace; "PWD Fields Export Setup"."Fct For Replace")
                                {
                                }
                                fieldelement(Function; "PWD Fields Export Setup".Function)
                                {
                                }
                                fieldelement(Field_Type; "PWD Fields Export Setup"."Field Type")
                                {
                                }
                                fieldelement(Constant_Value; "PWD Fields Export Setup"."Constant Value")
                                {
                                }
                            }
                        }
                    }
                }
            }
            tableelement("PWD WMS Setup"; "PWD WMS Setup")
            {
                XmlName = 'WMS_Setup';
                SourceTableView = SORTING("Primary Key");
                fieldelement(Primary_Key; "PWD WMS Setup"."Primary Key")
                {
                }
                fieldelement(WMS; "PWD WMS Setup".WMS)
                {
                }
                fieldelement(WMS_Company_Code; "PWD WMS Setup"."WMS Company Code")
                {
                }
                fieldelement(Location_Mandatory; "PWD WMS Setup"."Location Mandatory")
                {
                }
                fieldelement(WMS_Delivery; "PWD WMS Setup"."WMS Delivery")
                {
                }
                fieldelement(WMS_Shipment; "PWD WMS Setup"."WMS Shipment")
                {
                }
                fieldelement(Journal_Template_Name; "PWD WMS Setup"."Journal Template Name")
                {
                }
                fieldelement(Journal_Batch_Name; "PWD WMS Setup"."Journal Batch Name")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

