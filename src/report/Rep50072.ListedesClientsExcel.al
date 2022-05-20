report 50072 "PWD Liste des Clients (Excel)"
{
    Caption = 'Liste des Clients (Excel)';
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/ListeClientsExcel.rdl';
    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.");
            column("No"; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(Address2; "Address 2")
            {
            }
            column(PostCode; "Post Code")
            {
            }
            column(City; City)
            {
            }
            column(CountryRegionCode; "Country/Region Code")
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(FaxNo; "Fax No.")
            {

            }
            column(CustTxt; CustTxt)
            {
            }
            column(NoCaption; FieldCaption("No."))
            {
            }

            column(NameCaption; FieldCaption(Name))
            {
            }
            column(AddressCaption; FieldCaption(Address))
            {
            }
            column(Address2Caption; Add2Txt)
            {
            }
            column(PostCodeCaption; FieldCaption("Post Code"))
            {
            }
            column(CityCaption; FieldCaption(City))
            {
            }
            column(CountryRegionCodeCaption; FieldCaption("Country/Region Code"))
            {
            }
            column(PhoneNoCaption; FieldCaption("Phone No."))
            {
            }
            column(FaxNoCaption; FieldCaption("Fax No."))
            {
            }

            column(COMPANYNAME; CompanyName)
            {
            }
            column(PageText; PageTxt)
            {
            }
            trigger OnPreDataItem()
            begin
                LastFieldNo := FIELDNO("No.");

                // IF Exportexcel THEN BEGIN
                //     Sheet := Excel.Sheets.Add;
                //     Sheet.Name := 'Clients';
                //     // Sheet.Range('A1').Value := 'TYPE';
                //     //     Sheet.Range('B1').Value := 'N° CLIENT';
                //     //     Sheet.Range('C1').Value := 'NOM CLIENT';
                //     //     Sheet.Range('D1').Value := 'ADRESSE';
                //     //     Sheet.Range('E1').Value := 'ADRESSE2';
                //     //     Sheet.Range('F1').Value := 'CODE POSTAL';
                //     //     Sheet.Range('G1').Value := 'VILLE';
                //     //     Sheet.Range('H1').Value := 'PAYS';
                //     //     Sheet.Range('I1').Value := 'TELEPHONE';
                //     //     Sheet.Range('J1').Value := 'FAX';
                //     //     Sheet.Range('A1:J1').Font.Bold := TRUE;
                //     //     Sheet.Range('A1:J1').Font.ColorIndex := '2';
                //     //     Sheet.Range('A1:J1').Interior.ColorIndex := '55';
                //     Compteur := 1;
                // END;
            end;

            trigger OnAfterGetRecord()
            begin
                Compteur := Compteur + 1;

                // IF Exportexcel THEN BEGIN
                //     Sheet.Range('A' + FORMAT(Compteur)).Value := Customer."Customer Posting Group";
                //     Sheet.Range('B' + FORMAT(Compteur)).Value := Customer."No.";
                //     Sheet.Range('C' + FORMAT(Compteur)).Value := Customer.Name;
                //     Sheet.Range('D' + FORMAT(Compteur)).Value := Customer.Address;
                //     Sheet.Range('E' + FORMAT(Compteur)).Value := Customer."Address 2";
                //     Sheet.Range('F' + FORMAT(Compteur)).Value := Customer."Post Code";
                //     Sheet.Range('G' + FORMAT(Compteur)).Value := Customer.City;
                //     Sheet.Range('H' + FORMAT(Compteur)).Value := Customer."Country/Region Code";
                //     Sheet.Range('I' + FORMAT(Compteur)).Value := Customer."Phone No.";
                //     Sheet.Range('J' + FORMAT(Compteur)).Value := Customer."Fax No.";
                // END;
            end;

            // trigger OnPostDataItem()
            // begin
            //     IF Exportexcel THEN BEGIN
            //         Sheet.Range('A1:Z65535').Columns.AutoFit;
            //     END;
            // end;

        }
    }
    // requestpage
    // {
    //     layout
    //     {
    //         area(content)
    //         {
    //             group(Options)
    //             {
    //                 Caption = 'Options';
    //                 // field(Exportexcel; Exportexcel)
    //                 // {
    //                 //     Caption = 'Export Excel';
    //                 // }
    //             }
    //         }
    //     }
    //     actions
    //     {
    //         area(processing)
    //         {
    //         }
    //     }
    // }
    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Exportexcel: Boolean;
        Compteur: Integer;
        "No.": Code[20];
        Name: Text[30];
        Address: Text[30];
        "Address 2": Text[30];
        "Post Code": Text[30];
        City: Text[30];
        "Country Code": Text[30];
        "Phone No.": Text[30];
        "Fax No.": Text[30];
        CustTxt: Label 'Customer';
        PageTxt: Label 'Page';
        Add2Txt: Label 'Addresse 2';
}
