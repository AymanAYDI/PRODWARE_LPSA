report 50035 "PWD Item Extraction"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.13
    // P24578_002: RO : 21/11/2017 : Nouvelles demandes Cf. Echange Mail fin octobre 2017
    //                   - new Report
    // 
    // P24578_002: RO : 26/03/2018 : Correction suite test client.
    //                   - Add C/AL Code in trigger Routing Line - OnAfterGetRecord()
    // 
    // P24578_004: RO : 25/04/2018 : demande d'ajout colonne suite échange mail entre Anne et le client.
    //                   - Add C/AL Code in triggers Item - OnPreDataItem()
    //                                               Routing Line - OnAfterGetRecord()
    // 
    // //>>LAP2.20
    // P24578_007: RO : 05/09/2019 : Correction suite TPL
    //                   - Add C/AL Code in trigger Routing Line - OnAfterGetRecord()

    Caption = 'Item Extraction';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.", "Item Category Code", "PWD Product Group Code";
            dataitem("Routing Line"; "Routing Line")
            {
                DataItemLink = "Routing No." = FIELD("Routing No.");
                DataItemTableView = SORTING("Routing No.", "Version Code", "Operation No.");

                trigger OnAfterGetRecord()
                begin

                    FctAddDelimiterOnly();
                    TestOutStream.WriteText(AsciiToAnsi(Item."No."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(Item."PWD LPSA Description 1"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(Item."PWD LPSA Description 2"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(Item."Search Description"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(Item."Lot Size"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(Item."Routing No."));
                    FctAddSeparatorWithDelimitor();
                    //>>LAP2.13
                    TestOutStream.WriteText('''');
                    //<<LAP2.13
                    TestOutStream.WriteText(AsciiToAnsi(CodGActiveVersionCode));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(Format(RecGItemConfigurator."Product Type")));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator."Location Code"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator."Product Group Code"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator."Piece Type Stone"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator."Matter Stone"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator.Hole));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."External Diameter"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator.Thickness));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Piercing Min."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Piercing Max."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Diameter Min."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Diameter Max."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Thick Min."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Thick Max."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Hole Tol"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."External Diameter Tol"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Ep Min."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGItemConfigurator."Ep Max."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText('''');
                    TestOutStream.WriteText(AsciiToAnsi("Routing Line"."Operation No."));
                    FctAddSeparatorWithDelimitor();
                    if "Routing Line".Type = "Routing Line".Type::"Work Center" then begin

                        //>>LAP2.20
                        //   RecGWorkCenter.GET("Routing Line"."No.");
                        if not RecGWorkCenter.Get("Routing Line"."No.") then
                            RecGWorkCenter.Init();

                        //<<LAP2.20

                        TestOutStream.WriteText(AsciiToAnsi("Routing Line"."Work Center No."));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(AsciiToAnsi(RecGWorkCenter.Name));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(AsciiToAnsi(RecGWorkCenter."Shop Calendar Code"));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText('');
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText('');
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText('');
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText('');
                    end else begin

                        //>>LAP2.20
                        //   RecGMachineCenter.GET("Routing Line"."No.");
                        if not RecGMachineCenter.Get("Routing Line"."No.") then
                            RecGMachineCenter.Init();
                        //   RecGWorkCenter.GET("Routing Line"."Work Center No.");
                        if not RecGWorkCenter.Get("Routing Line"."Work Center No.") then
                            RecGWorkCenter.Init();
                        //>>LAP2.20

                        TestOutStream.WriteText(AsciiToAnsi("Routing Line"."Work Center No."));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(AsciiToAnsi(RecGWorkCenter.Name));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(AsciiToAnsi(RecGWorkCenter."Shop Calendar Code"));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(AsciiToAnsi("Routing Line"."No."));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(AsciiToAnsi(RecGMachineCenter.Name));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(Format(RecGMachineCenter.Capacity));
                        FctAddSeparatorWithDelimitor();
                        TestOutStream.WriteText(Format(RecGMachineCenter.Efficiency));
                    end;
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format("Routing Line"."Setup Time"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format("Routing Line"."Run Time"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format("Routing Line"."Move Time"));
                    //>>LAP2.13 (P24578_004)
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format("Routing Line"."Scrap Factor %"));
                    //<<LAP2.13 (P24578_004)

                    FctAddDelimiterOnly();
                    TestOutStream.WriteText();
                end;

                trigger OnPreDataItem()
                begin
                    "Routing Line".SetRange("Version Code", CodGActiveVersionCode);
                end;
            }

            trigger OnAfterGetRecord()
            var
                RecLRoutingHeader: Record "Routing Header";
                RecLRoutingVersion: Record "Routing Version";
            begin
                Bdialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                if "Routing No." = '' then
                    CurrReport.Skip();

                RecGItemConfigurator.Reset();
                RecGItemConfigurator.SetCurrentKey("Item Code");
                RecGItemConfigurator.SetRange("Item Code", Item."No.");
                if not RecGItemConfigurator.FindFirst() then
                    CurrReport.Skip();

                CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion("Routing No.", WorkDate(), true);
                if CodGActiveVersionCode = '' then begin
                    if not RecLRoutingHeader.Get("Routing No.") then
                        CurrReport.Skip();

                    if RecLRoutingHeader.Status <> RecLRoutingHeader.Status::Certified then
                        CurrReport.Skip();
                end else begin
                    if not RecLRoutingVersion.Get("Routing No.", CodGActiveVersionCode) then
                        CurrReport.Skip();

                    if RecLRoutingVersion.Status <> RecLRoutingVersion.Status::Certified then
                        CurrReport.Skip();
                end;
            end;

            trigger OnPostDataItem()
            begin
                Bdialog.Close();
            end;

            trigger OnPreDataItem()
            begin
                Bdialog.Open('Enregistrement restants #1#################');
                IntGCounter := Count;

                //Création de la ligne de titre
                FctAddDelimiterOnly();
                TestOutStream.WriteText(AsciiToAnsi(Item.FieldCaption("No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(Item.FieldCaption("PWD LPSA Description 1")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(Item.FieldCaption("PWD LPSA Description 2")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(Item.FieldCaption("Search Description")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(Item.FieldCaption("Lot Size")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(Item.FieldCaption("Routing No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Routing Line".FieldCaption("Version Code")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator.FieldCaption("Product Type")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator.FieldCaption("Location Code")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItemConfigurator.FieldCaption("Product Group Code")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Piece Type Stone")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Matter Stone")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption(Hole)));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("External Diameter")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption(Thickness)));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Piercing Min.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Piercing Max.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Diameter Min.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Diameter Max.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Thick Min.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Thick Max.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Hole Tol")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("External Diameter Tol")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Ep Min.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Ep Max.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Routing Line".FieldCaption("Operation No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(CstG002));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(CstG003));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(CstG004));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(CstG005));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(CstG006));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGMachineCenter.FieldCaption(Capacity)));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGMachineCenter.FieldCaption(Efficiency)));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Routing Line".FieldCaption("Setup Time")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Routing Line".FieldCaption("Run Time")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Routing Line".FieldCaption("Move Time")));
                //>>LAP2.13 (P24578_004)
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Routing Line".FieldCaption("Scrap Factor %")));
                //<<LAP2.13 (P24578_004)

                FctAddDelimiterOnly();
                TestOutStream.WriteText();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control1000000000)
                {
                    Caption = 'Options';
                    field(TxtGFileName; TxtGFileName)
                    {
                        Caption = 'Fichier à exporter';
                        ApplicationArea = All;
                        // trigger OnDrillDown()
                        // var
                        //     FileMgt: codeunit "File Management";
                        //     TempBlob: Codeunit "Temp Blob";
                        //     FileName: Text;
                        // begin
                        //     FileMgt.BLOBExport(TempBlob, FileName, true);
                        //     TxtGFileName := FileName;
                        // end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        MyFile.Close();
        Message('Traitement terminé');
    end;

    trigger OnPreReport()
    begin
        if TxtGFileName = '' then
            Error(CstG010);

        if not MyFile.Create(TxtGFileName) then begin
            Erase(TxtGFileName);
            MyFile.Create(TxtGFileName);
        end;
        MyFile.CreateOutStream(TestOutStream);
    end;

    var
        RecGMachineCenter: Record "Machine Center";
        RecGItemConfigurator: Record "PWD Item Configurator";
        RecGWorkCenter: Record "Work Center";
        CduGVersionMgt: Codeunit VersionManagement;
        Finded: Boolean;
        ANSIChar: array[255] of Char;
        ASCIIChar: Char;
        CodGActiveVersionCode: Code[20];
        Bdialog: Dialog;
        MyFile: File;
        ASCIIDec: Integer;
        i: Integer;
        IntGCounter: Integer;
        pos: Integer;
        CstG002: Label 'N° de centre de charge';
        CstG003: Label 'Désignation centre';
        CstG004: Label 'Code Calendrier du centre';
        CstG005: Label 'N° Poste de charge';
        CstG006: Label 'Désignation poste';
        CstG010: Label 'Merci de spécifier un fichier d''export';
        TestOutStream: OutStream;
        TxtGFileName: Text[1024];


    procedure AsciiToAnsi(TextAscii: Text[250]) TextAnsi: Text[250]
    begin
        InitCharArray();
        TextAnsi := TextAscii;
        for pos := 1 to StrLen(TextAnsi) do begin
            ASCIIChar := TextAnsi[pos];
            ASCIIDec := ASCIIChar;
            TextAnsi[pos] := ANSIChar[ASCIIDec];
        end;
    end;


    procedure AnsiToAscii(var TextAnsi: Text[250]) TextAscii: Text[250]
    begin
        InitCharArray();
        TextAscii := TextAnsi;
        for pos := 1 to StrLen(TextAscii) do begin
            ASCIIChar := TextAscii[pos];
            ASCIIDec := ASCIIChar;
            i := 0;
            Finded := false;
            while ((not Finded) and (i < 255)) do begin
                i += 1;
                if (ANSIChar[i] = ASCIIChar) then begin
                    Finded := true;
                    TextAscii[pos] := i;
                end;
            end;
        end;
    end;

    local procedure InitCharArray()
    begin
        Clear(ANSIChar);
        for i := 1 to 127 do
            ANSIChar[i] := i;

        /*Ç*/
        ANSIChar[128] := 199;
        /*ü*/
        ANSIChar[129] := 252;
        /*é*/
        ANSIChar[130] := 233;
        /*â*/
        ANSIChar[131] := 226;
        /*ä*/
        ANSIChar[132] := 228;
        /*à*/
        ANSIChar[133] := 224;
        /*å*/
        ANSIChar[134] := 229;
        /*ç*/
        ANSIChar[135] := 231;
        /*ê*/
        ANSIChar[136] := 234;
        /*ë*/
        ANSIChar[137] := 235;
        /*è*/
        ANSIChar[138] := 232;
        /*ï*/
        ANSIChar[139] := 239;
        /*î*/
        ANSIChar[140] := 238;
        /*ì*/
        ANSIChar[141] := 236;
        /*Ä*/
        ANSIChar[142] := 196;
        /*Å*/
        ANSIChar[143] := 197;
        /*É*/
        ANSIChar[144] := 201;
        /*æ*/
        ANSIChar[145] := 230;
        /*Æ*/
        ANSIChar[146] := 198;
        /*ô*/
        ANSIChar[147] := 244;
        /*ö*/
        ANSIChar[148] := 246;
        /*ò*/
        ANSIChar[149] := 242;
        /*û*/
        ANSIChar[150] := 251;
        /*ù*/
        ANSIChar[151] := 249;
        /*ÿ*/
        ANSIChar[152] := 255;
        /*Ö*/
        ANSIChar[153] := 214;
        /*Ü*/
        ANSIChar[154] := 220;
        /*ø*/
        ANSIChar[155] := 248;
        /*£*/
        ANSIChar[156] := 163;
        /*Ø*/
        ANSIChar[157] := 216;
        /*×*/
        ANSIChar[158] := 215;
        /*ƒ*/
        ANSIChar[159] := 131;
        /*á*/
        ANSIChar[160] := 225;
        /*í*/
        ANSIChar[161] := 237;
        /*ó*/
        ANSIChar[162] := 243;
        /*ú*/
        ANSIChar[163] := 250;
        /*ñ*/
        ANSIChar[164] := 241;
        /*Ñ*/
        ANSIChar[165] := 209;
        /*ª*/
        ANSIChar[166] := 170;
        /*º*/
        ANSIChar[167] := 186;
        /*¿*/
        ANSIChar[168] := 191;
        /*®*/
        ANSIChar[169] := 174;
        /*¬*/
        ANSIChar[170] := 172;
        /*½*/
        ANSIChar[171] := 189;
        /*¼*/
        ANSIChar[172] := 188;
        /*¡*/
        ANSIChar[173] := 161;
        /*«*/
        ANSIChar[174] := 171;
        /*»*/
        ANSIChar[175] := 187;
        /*€*/
        ANSIChar[176] := 128;
        /**/
        ANSIChar[177] := 129;
        /*‚*/
        ANSIChar[178] := 130;
        /*„*/
        ANSIChar[179] := 132;
        /*…*/
        ANSIChar[180] := 133;
        /*Á*/
        ANSIChar[181] := 193;
        /*Â*/
        ANSIChar[182] := 194;
        /*À*/
        ANSIChar[183] := 192;
        /*©*/
        ANSIChar[184] := 169;
        /*†*/
        ANSIChar[185] := 134;
        /*‡*/
        ANSIChar[186] := 135;
        /*ˆ*/
        ANSIChar[187] := 136;
        /*‰*/
        ANSIChar[188] := 137;
        /*¢*/
        ANSIChar[189] := 162;
        /*¥*/
        ANSIChar[190] := 165;
        /*Š*/
        ANSIChar[191] := 138;
        /*‹*/
        ANSIChar[192] := 139;
        /*Œ*/
        ANSIChar[193] := 140;
        /**/
        ANSIChar[194] := 141;
        /*Ž*/
        ANSIChar[195] := 142;
        /**/
        ANSIChar[196] := 143;
        /**/
        ANSIChar[197] := 144;
        /*ã*/
        ANSIChar[198] := 227;
        /*Ã*/
        ANSIChar[199] := 195;
        /*‘*/
        ANSIChar[200] := 145;
        /*’*/
        ANSIChar[201] := 146;
        /*“*/
        ANSIChar[202] := 147;
        /*”*/
        ANSIChar[203] := 148;
        /*•*/
        ANSIChar[204] := 149;
        /*–*/
        ANSIChar[205] := 150;
        /*—*/
        ANSIChar[206] := 151;
        /*¤*/
        ANSIChar[207] := 164;
        /*ð*/
        ANSIChar[208] := 240;
        /*Ð*/
        ANSIChar[209] := 208;
        /*Ê*/
        ANSIChar[210] := 202;
        /*Ë*/
        ANSIChar[211] := 203;
        /*È*/
        ANSIChar[212] := 200;
        /*?*/
        ANSIChar[213] := 63;
        /*Í*/
        ANSIChar[214] := 205;
        /*Î*/
        ANSIChar[215] := 206;
        /*Ï*/
        ANSIChar[216] := 207;
        /*™*/
        ANSIChar[217] := 153;
        /*š*/
        ANSIChar[218] := 154;
        /*›*/
        ANSIChar[219] := 155;
        /*œ*/
        ANSIChar[220] := 156;
        /*¦*/
        ANSIChar[221] := 166;
        /*Ì*/
        ANSIChar[222] := 204;
        /**/
        ANSIChar[223] := 157;
        /*Ó*/
        ANSIChar[224] := 211;
        /*ß*/
        ANSIChar[225] := 223;
        /*Ô*/
        ANSIChar[226] := 212;
        /*Ò*/
        ANSIChar[227] := 210;
        /*õ*/
        ANSIChar[228] := 245;
        /*Õ*/
        ANSIChar[229] := 213;
        /*µ*/
        ANSIChar[230] := 181;
        /*þ*/
        ANSIChar[231] := 254;
        /*Þ*/
        ANSIChar[232] := 222;
        /*Ú*/
        ANSIChar[233] := 218;
        /*Û*/
        ANSIChar[234] := 219;
        /*Ù*/
        ANSIChar[235] := 217;
        /*ý*/
        ANSIChar[236] := 253;
        /*Ý*/
        ANSIChar[237] := 221;
        /*¯*/
        ANSIChar[238] := 175;
        /*´*/
        ANSIChar[239] := 180;
        /*­*/
        ANSIChar[240] := 173;
        /*±*/
        ANSIChar[241] := 177;
        /*?*/
        ANSIChar[242] := 63;
        /*¾*/
        ANSIChar[243] := 190;
        /*¶*/
        ANSIChar[244] := 182;
        /*§*/
        ANSIChar[245] := 167;
        /*÷*/
        ANSIChar[246] := 247;
        /*¸*/
        ANSIChar[247] := 184;
        /*°*/
        ANSIChar[248] := 176;
        /*¨*/
        ANSIChar[249] := 168;
        /*·*/
        ANSIChar[250] := 183;
        /*¹*/
        ANSIChar[251] := 185;
        /*³*/
        ANSIChar[252] := 179;
        /*²*/
        ANSIChar[253] := 178;
        /*?*/
        ANSIChar[254] := 63;

    end;


    procedure FctAddDelimiterOnly()
    begin
        TestOutStream.WriteText('');
    end;


    procedure FctAddSeparatorWithDelimitor()
    begin
        TestOutStream.WriteText('');
        TestOutStream.WriteText(';');
        TestOutStream.WriteText('');
    end;
}

