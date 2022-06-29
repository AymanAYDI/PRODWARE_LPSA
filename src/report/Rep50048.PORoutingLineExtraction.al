report 50048 "PWD PO Routing Line Extraction"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>LAP2.21
    // P24578_009: RO : 28/10/2019 : cf FED-LAPIERRETTE-10102019- MAJ Ligne Gamme OF
    //                   - New report

    Caption = 'PO Routing Line Extraction';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        dataitem("Prod. Order Routing Line"; "Prod. Order Routing Line")
        {
            DataItemTableView = WHERE(Status = FILTER(Released), "Routing Status" = FILTER(Planned));

            trigger OnAfterGetRecord()
            begin
                Bdialog.Update(1, IntGCounter);
                IntGCounter -= 1;

                if not RecGProductionOrder.Get("Prod. Order Routing Line".Status, "Prod. Order Routing Line"."Prod. Order No.") then
                    CurrReport.Skip();

                if not RecGItem.Get(RecGProductionOrder."Source No.") then
                    CurrReport.Skip();

                if not RecGProdOrderLine.Get("Prod. Order Routing Line".Status,
                                      "Prod. Order Routing Line"."Prod. Order No.",
                                      "Prod. Order Routing Line"."Routing Reference No.") then
                    CurrReport.Skip();

                RecGItemConfigurator.Reset();
                RecGItemConfigurator.SetCurrentKey("Item Code");
                RecGItemConfigurator.SetRange("Item Code", RecGItem."No.");
                if not RecGItemConfigurator.FindFirst() then
                    CurrReport.Skip();


                FctAddDelimiterOnly();
                TestOutStream.WriteText(AsciiToAnsi(Format("Prod. Order Routing Line".Status)));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line"."Prod. Order No."));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(Format("Prod. Order Routing Line"."Routing Reference No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line"."Routing No."));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem."No."));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem."PWD LPSA Description 1"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem."PWD LPSA Description 2"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem."Search Description"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(Format(RecGItem."Lot Size"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem."Routing No."));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText('''');
                TestOutStream.WriteText(AsciiToAnsi(RecGProdOrderLine."Routing Version Code"));
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
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line"."Operation No."));
                FctAddSeparatorWithDelimitor();
                if "Prod. Order Routing Line".Type = "Prod. Order Routing Line".Type::"Work Center" then begin

                    if not RecGWorkCenter.Get("Prod. Order Routing Line"."No.") then
                        RecGWorkCenter.Init();

                    TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line"."Work Center No."));
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

                    if not RecGMachineCenter.Get("Prod. Order Routing Line"."No.") then
                        RecGMachineCenter.Init();
                    if not RecGWorkCenter.Get("Prod. Order Routing Line"."Work Center No.") then
                        RecGWorkCenter.Init();

                    TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line"."Work Center No."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGWorkCenter.Name));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGWorkCenter."Shop Calendar Code"));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line"."No."));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(AsciiToAnsi(RecGMachineCenter.Name));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGMachineCenter.Capacity));
                    FctAddSeparatorWithDelimitor();
                    TestOutStream.WriteText(Format(RecGMachineCenter.Efficiency));
                end;
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(Format("Prod. Order Routing Line"."Setup Time"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(Format("Prod. Order Routing Line"."Run Time"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(Format("Prod. Order Routing Line"."Wait Time"));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(Format("Prod. Order Routing Line"."Move Time"));

                FctAddDelimiterOnly();
                TestOutStream.WriteText();
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
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption(Status)));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Prod. Order No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Routing Reference No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Routing No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGProductionOrder.FieldCaption("Source No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem.FieldCaption("PWD LPSA Description 1")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem.FieldCaption("PWD LPSA Description 2")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem.FieldCaption("Search Description")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem.FieldCaption("Lot Size")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGItem.FieldCaption("Routing No.")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi(RecGProdOrderLine.FieldCaption("Routing Version Code")));
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
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Operation No.")));
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
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Setup Time")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Run Time")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Wait Time")));
                FctAddSeparatorWithDelimitor();
                TestOutStream.WriteText(AsciiToAnsi("Prod. Order Routing Line".FieldCaption("Move Time")));

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
                    Caption = 'Export';
                    field(TxtGFileNameF; TxtGFileName)
                    {
                        Caption = 'Fichier à exporter';
                        ApplicationArea = All;
                        trigger OnAssistEdit()
                        var
                            CduGCommonDialogMgt: Codeunit "File management";
                            CstG001: label 'Fichier à exporte';
                        begin
                            TxtGFileName := CduGCommonDialogMgt.UploadFile(CstG001, TxtGFileName);
                        end;
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
        RecGItem: Record Item;
        RecGMachineCenter: Record "Machine Center";
        RecGProdOrderLine: Record "Prod. Order Line";
        RecGProductionOrder: Record "Production Order";
        RecGItemConfigurator: Record "PWD Item Configurator";
        RecGWorkCenter: Record "Work Center";
        Finded: Boolean;
        ANSIChar: array[255] of Char;
        ASCIIChar: Char;
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

