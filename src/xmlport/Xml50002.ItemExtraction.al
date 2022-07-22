xmlport 50002 "PWD Item Extraction"
{
    Caption = 'PWD Item Extraction';
    Direction = Export;
    Format = VariableText;
    FieldSeparator = ';';
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(ItemHeader; Integer)
            {
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(CaptionNo)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionNo := AsciiToAnsi(Item.FieldCaption("No."));
                    end;
                }
                textelement(CaptionDescription1)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionDescription1 := AsciiToAnsi(Item.FieldCaption("PWD LPSA Description 1"));
                    end;
                }
                textelement(CaptionDescription2)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionDescription2 := AsciiToAnsi(Item.FieldCaption("PWD LPSA Description 2"));
                    end;
                }
                textelement(CaptionSearchDescription)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionSearchDescription := AsciiToAnsi(Item.FieldCaption("Search Description"));
                    end;
                }
                textelement(CaptionLotSize)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionLotSize := AsciiToAnsi(Item.FieldCaption("Lot Size"));
                    end;
                }
                textelement(CaptionRoutingNo)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionRoutingNo := AsciiToAnsi(Item.FieldCaption("Routing No."));
                    end;
                }
                textelement(CaptionVersionCode)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionVersionCode := AsciiToAnsi(RoutingLine.FieldCaption("Version Code"));
                    end;
                }
                textelement(CaptionProductType)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionProductType := AsciiToAnsi(RecGItemConfigurator.FieldCaption("Product Type"));
                    end;
                }
                textelement(CaptionLocationCode)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionLocationCode := AsciiToAnsi(RecGItemConfigurator.FieldCaption("Location Code"));
                    end;
                }
                textelement(CaptionProdGpCode)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionProdGpCode := AsciiToAnsi(RecGItemConfigurator.FieldCaption("Product Group Code"));
                    end;
                }
                textelement(CaptionPieceTypeStone)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionPieceTypeStone := 'PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Piece Type Stone"));
                    end;
                }
                textelement(CaptionMatterStone)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionMatterStone := 'PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Matter Stone"));
                    end;
                }
                textelement(CaptionHole)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionHole := 'PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption(Hole));
                    end;
                }
                textelement(CaptionExternalDiameter)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionExternalDiameter := 'PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("External Diameter"));
                    end;
                }
                textelement(CaptionThickness)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionThickness := 'PIE_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption(Thickness));
                    end;
                }
                textelement(CaptionPiercingMin)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionPiercingMin := 'PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Piercing Min."));
                    end;
                }
                textelement(CaptioniercingMax)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptioniercingMax := 'PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Piercing Max."));
                    end;
                }
                textelement(CaptionDiameterMin)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionDiameterMin := 'PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Diameter Min."));
                    end;
                }
                textelement(CaptionDiameterMax)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionDiameterMax := 'PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Diameter Max."));
                    end;
                }
                textelement(CaptionThickMin)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionThickMin := 'PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Thick Min."));
                    end;
                }
                textelement(CaptionThickMax)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionThickMax := 'PREP_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Thick Max."));
                    end;
                }
                textelement(CaptionHoleTol)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionHoleTol := 'SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Hole Tol"));
                    end;
                }
                textelement(CaptionExtDiamTol)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionExtDiamTol := 'SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("External Diameter Tol"));
                    end;
                }
                textelement(CaptionEpMin)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionEpMin := 'SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Ep Min."));
                    end;
                }
                textelement(CaptionEpMax)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionEpMax := 'SEMI.OUV_' + AsciiToAnsi(RecGItemConfigurator.FieldCaption("Ep Max."));
                    end;
                }
                textelement(CaptionOperationNo)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionOperationNo := AsciiToAnsi(RoutingLine.FieldCaption("Operation No."));
                    end;
                }
                textelement(CaptionCstG002)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionCstG002 := AsciiToAnsi(CstG002);
                    end;
                }
                textelement(CaptionCstG003)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionCstG003 := AsciiToAnsi(CstG003);
                    end;
                }
                textelement(CaptionCstG004)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionCstG004 := AsciiToAnsi(CstG004);
                    end;
                }
                textelement(CaptionCstG005)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionCstG005 := AsciiToAnsi(CstG005);
                    end;
                }
                textelement(CaptionCstG006)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionCstG006 := AsciiToAnsi(CstG006);
                    end;
                }
                textelement(CaptionCapacity)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionCapacity := AsciiToAnsi(RecGMachineCenter.FieldCaption(Capacity));
                    end;
                }
                textelement(CaptionEfficiency)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionEfficiency := AsciiToAnsi(RecGMachineCenter.FieldCaption(Efficiency));
                    end;
                }
                textelement(CaptionSetupTime)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionSetupTime := AsciiToAnsi(RoutingLine.FieldCaption("Setup Time"));
                    end;
                }
                textelement(CaptionRunTime)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionRunTime := AsciiToAnsi(RoutingLine.FieldCaption("Run Time"));
                    end;
                }
                textelement(CaptionMoveTime)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionMoveTime := AsciiToAnsi(RoutingLine.FieldCaption("Move Time"));
                    end;
                }
                textelement(CaptionScrapFactor)
                {
                    trigger onbeforePassvariable()
                    begin
                        CaptionScrapFactor := AsciiToAnsi(RoutingLine.FieldCaption("Scrap Factor %"));
                    end;
                }
            }
            tableelement(Item; Item)
            {
                RequestFilterFields = "No.", "Item Category Code", "PWD Product Group Code";
                tableelement(RoutingLine; "Routing Line")
                {
                    textelement(ItemNo)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ItemNo := AsciiToAnsi(Item."No.");
                        end;
                    }
                    textelement(LPSADescription1)
                    {
                        trigger onbeforePassvariable();
                        begin
                            LPSADescription1 := AsciiToAnsi(Item."PWD LPSA Description 1");
                        end;
                    }
                    textelement(LPSADescription2)
                    {
                        trigger onbeforePassvariable();
                        begin
                            LPSADescription2 := AsciiToAnsi(Item."PWD LPSA Description 1");
                        end;
                    }
                    textelement(SearchDescription)
                    {
                        trigger onbeforePassvariable();
                        begin
                            SearchDescription := AsciiToAnsi(Item."Search Description");
                        end;
                    }
                    textelement(LotSize)
                    {
                        trigger onbeforePassvariable();
                        begin
                            LotSize := Format(Item."Lot Size");
                        end;
                    }
                    textelement(RoutingNo)
                    {
                        trigger onbeforePassvariable()
                        begin
                            RoutingNo := AsciiToAnsi(Item."Routing No.");
                        end;
                    }
                    textelement(txtType)
                    {
                        trigger onbeforePassvariable()
                        var
                            txt: label '''';
                        begin
                            txtType := Format(txt);
                        end;
                    }
                    textelement(CodGActiveVersionCodeV)
                    {
                        trigger onbeforePassvariable()
                        begin
                            CodGActiveVersionCodeV := AsciiToAnsi(CodGActiveVersionCode);
                        end;
                    }
                    textelement(ProductType)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ProductType := AsciiToAnsi(Format(RecGItemConfigurator."Product Type"));
                        end;
                    }
                    textelement(LocationCode)
                    {
                        trigger onbeforePassvariable()
                        begin
                            LocationCode := AsciiToAnsi(RecGItemConfigurator."Location Code");
                        end;
                    }
                    textelement(ProductGroupCode)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ProductGroupCode := AsciiToAnsi(RecGItemConfigurator."Product Group Code");
                        end;
                    }
                    textelement(PieceTypeStone)
                    {
                        trigger onbeforePassvariable()
                        begin
                            PieceTypeStone := AsciiToAnsi(RecGItemConfigurator."Piece Type Stone");
                        end;
                    }
                    textelement(MatterStone)
                    {
                        trigger onbeforePassvariable()
                        begin
                            MatterStone := AsciiToAnsi(RecGItemConfigurator."Matter Stone");
                        end;
                    }
                    textelement(Hole)
                    {
                        trigger onbeforePassvariable()
                        begin
                            Hole := Format(RecGItemConfigurator.Hole);
                        end;
                    }
                    textelement(ExternalDiameter)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ExternalDiameter := Format(RecGItemConfigurator."External Diameter");
                        end;
                    }
                    textelement(Thickness)
                    {
                        trigger onbeforePassvariable()
                        begin
                            Thickness := Format(RecGItemConfigurator.Thickness);
                        end;
                    }
                    textelement(PiercingMin)
                    {
                        trigger onbeforePassvariable()
                        begin
                            PiercingMin := Format(RecGItemConfigurator."Piercing Min.");
                        end;
                    }

                    textelement(PiercingMax)
                    {
                        trigger onbeforePassvariable()
                        begin
                            PiercingMax := Format(RecGItemConfigurator."Piercing Max.");
                        end;
                    }
                    textelement(DiameterMin)
                    {
                        trigger onbeforePassvariable()
                        begin
                            DiameterMin := Format(RecGItemConfigurator."Diameter Min.");
                        end;
                    }
                    textelement(DiameterMax)
                    {
                        trigger onbeforePassvariable()
                        begin
                            DiameterMax := Format(RecGItemConfigurator."Diameter Max.");
                        end;
                    }
                    textelement(ThickMin)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ThickMin := Format(RecGItemConfigurator."Thick Min.");
                        end;
                    }
                    textelement(ThickMax)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ThickMax := Format(RecGItemConfigurator."Thick Max.");
                        end;
                    }
                    textelement(HoleTol)
                    {
                        trigger onbeforePassvariable()
                        begin
                            HoleTol := Format(RecGItemConfigurator."Hole Tol");
                        end;
                    }
                    textelement(ExternalDiameterTol)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ExternalDiameterTol := Format(RecGItemConfigurator."External Diameter Tol");
                        end;
                    }
                    textelement(EpMin)
                    {
                        trigger onbeforePassvariable()
                        begin
                            EpMin := Format(RecGItemConfigurator."Ep Min.");
                        end;
                    }
                    textelement(EpMax)
                    {
                        trigger onbeforePassvariable()
                        begin
                            EpMax := Format(RecGItemConfigurator."Ep Max.");
                        end;
                    }
                    textelement(txtType2)
                    {
                        trigger onbeforePassvariable()
                        var
                            txt: label '''';
                        begin
                            txtType2 := Format(txt);
                        end;
                    }
                    textelement(OperationNo)
                    {
                        trigger onbeforePassvariable()
                        begin
                            OperationNo := AsciiToAnsi(RoutingLine."Operation No.");
                        end;
                    }
                    textelement(WorkCenterNo)
                    {
                        trigger onbeforePassvariable()
                        begin
                            WorkCenterNo := AsciiToAnsi(RoutingLine."Work Center No.");
                        end;
                    }
                    textelement(Name)
                    {
                        trigger onbeforePassvariable()
                        begin
                            Name := NameV;
                        end;
                    }
                    textelement(ShopCalendarCode)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ShopCalendarCode := ShopCalendarCodeV;
                        end;
                    }
                    textelement(RoutingLineNo)
                    {
                        trigger onbeforePassvariable()
                        begin
                            RoutingLineNo := NoV;
                        end;
                    }
                    textelement(RecGMachineCenterName)
                    {
                        trigger onbeforePassvariable()
                        begin
                            RecGMachineCenterName := NameV;
                        end;
                    }
                    textelement(Capacity)
                    {
                        trigger onbeforePassvariable()
                        begin
                            Capacity := CapacityV;
                        end;
                    }
                    textelement(Efficiency)
                    {
                        trigger onbeforePassvariable()
                        begin
                            Efficiency := EfficiencyV;
                        end;
                    }
                    textelement(SetupTime)
                    {
                        trigger onbeforePassvariable()
                        begin
                            SetupTime := Format(RoutingLine."Setup Time");
                        end;
                    }
                    textelement(RunTime)
                    {
                        trigger onbeforePassvariable()
                        begin
                            RunTime := Format(RoutingLine."Run Time");
                        end;
                    }
                    textelement(MoveTime)
                    {
                        trigger onbeforePassvariable()
                        begin
                            MoveTime := Format(RoutingLine."Move Time");
                        end;
                    }
                    textelement(ScrapFactor)
                    {
                        trigger onbeforePassvariable()
                        begin
                            ScrapFactor := Format(RoutingLine."Scrap Factor %");
                        end;
                    }
                    trigger OnPreXmlItem()
                    begin
                        RoutingLine.SetCurrentKey("Routing No.", "Version Code", "Operation No.");
                        RoutingLine.SetRange("Routing No.", Item."Routing No.");
                        RoutingLine.SetRange("Version Code", CodGActiveVersionCode);
                    end;
                }
                trigger OnAfterGetRecord()
                var
                    RecLRoutingHeader: Record "Routing Header";
                    RecLRoutingVersion: Record "Routing Version";
                begin
                    Bdialog.Update(1, IntGCounter);
                    IntGCounter -= 1;

                    if item."Routing No." = '' then
                        currXMLport.Skip();

                    RecGItemConfigurator.Reset();
                    RecGItemConfigurator.SetCurrentKey("Item Code");
                    RecGItemConfigurator.SetRange("Item Code", Item."No.");
                    if not RecGItemConfigurator.FindFirst() then
                        currXMLport.Skip();

                    CodGActiveVersionCode := CduGVersionMgt.GetRtngVersion(item."Routing No.", WorkDate(), true);
                    if CodGActiveVersionCode = '' then begin
                        if not RecLRoutingHeader.Get(item."Routing No.") then
                            currXMLport.Skip();

                        if RecLRoutingHeader.Status <> RecLRoutingHeader.Status::Certified then
                            currXMLport.Skip();
                    end else begin
                        if not RecLRoutingVersion.Get(item."Routing No.", CodGActiveVersionCode) then
                            currXMLport.Skip();

                        if RecLRoutingVersion.Status <> RecLRoutingVersion.Status::Certified then
                            currXMLport.Skip();
                    end;
                    if RoutingLine.Type = RoutingLine.Type::"Work Center" then begin
                        //>>LAP2.20
                        //   RecGWorkCenter.GET("Routing Line"."No.");
                        if not RecGWorkCenter.Get(RoutingLine."No.") then
                            RecGWorkCenter.Init();
                        //<<LAP2.20
                        NameV := AsciiToAnsi(RecGWorkCenter.Name);
                        ShopCalendarCodeV := AsciiToAnsi(RecGWorkCenter."Shop Calendar Code");
                        NoV := '';
                        NameV2 := '';
                        CapacityV := '';
                        EfficiencyV := '';
                    end else begin

                        //>>LAP2.20
                        //   RecGMachineCenter.GET("Routing Line"."No.");
                        if not RecGMachineCenter.Get(RoutingLine."No.") then
                            RecGMachineCenter.Init();
                        //   RecGWorkCenter.GET("Routing Line"."Work Center No.");
                        if not RecGWorkCenter.Get(RoutingLine."Work Center No.") then
                            RecGWorkCenter.Init();
                        //>>LAP2.20
                        NameV := AsciiToAnsi(RecGWorkCenter.Name);
                        ShopCalendarCodeV := AsciiToAnsi(RecGWorkCenter."Shop Calendar Code");
                        NoV := AsciiToAnsi(RoutingLine."No.");
                        NameV2 := AsciiToAnsi(RecGMachineCenter.Name);
                        CapacityV := Format(RecGMachineCenter.Capacity);
                        EfficiencyV := Format(RecGMachineCenter.Efficiency);
                    end;
                end;

                trigger OnPreXmlItem()
                begin
                    Bdialog.Open('Enregistrement restants #1#################');

                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Traitement terminé');
    end;

    trigger OnPreXmlPort()
    begin
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
        NameV: Text[100];
        ShopCalendarCodeV: Code[10];
        NoV: Code[20];
        NameV2: Text[50];
        CapacityV: Text[50];
        EfficiencyV: Text[50];

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
