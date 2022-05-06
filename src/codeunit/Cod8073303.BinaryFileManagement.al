codeunit 8073303 "PWD Binary File Management"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                                                                |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect1.5
    // WMS-FE007_15.001:GR 05/07/2011 Receipt
    //                                   - Create Object
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    begin
        FctOpenFile2();
    end;

    var
        BooGEOF: Boolean;
        BooGEOL: Boolean;
        ChaGTmp: Char;
        CodGFieldDelimiter: Code[10];
        CodGFieldSeparator: Code[10];
        DiaGWin: Dialog;
        FilGFile: File;
        InsGInstream: InStream;
        i: Integer;
        IntGFileSize: Integer;
        IntGLineSize: Integer;
        IntGNbLine: Integer;
        CstG001: Label 'Progress @@@1@@@@@@@@';
        CstG002: Label 'Xml File is not supported.';
        OptGFileType: Option Xml,"with separator","File Position";
        OusGOustream: OutStream;
        TxtGChaTab: array[1500] of Text[1];
        TxtGChaTab2: array[1100] of Text[1];
        TxtGFileName: Text[250];


    procedure FctOpenFile(TxtPFileName: Text[250])
    begin
        FilGFile.TextMode(false);
        FilGFile.Open(TxtPFileName);
        IntGNbLine := 0;
        i := 1;
        FilGFile.CreateInStream(InsGInstream);
        BooGEOF := false;

        if GuiAllowed then begin
            DiaGWin.Open(CstG001);
            IntGFileSize := FctRetreiveFileSize();
            IntGLineSize := 0;
        end;
    end;


    procedure FctOpenStream(InsPInstream: InStream)
    begin
        i := 1;
        InsGInstream := InsPInstream;
        BooGEOF := false;

        if GuiAllowed then begin
            DiaGWin.Open(CstG001);
            IntGFileSize := 1;
            IntGLineSize := 0;
        end;
    end;


    procedure FctCreateFile(TxtPFileName: Text[250])
    begin
        FilGFile.TextMode(false);
        FilGFile.WriteMode(false);
        FilGFile.Create(TxtPFileName);
        IntGNbLine := 0;
        i := 1;
        FilGFile.CreateOutStream(OusGOustream);
        BooGEOF := false;
    end;


    procedure FctReadLine(): Boolean
    begin
        BooGEOL := false;
        Clear(TxtGChaTab);
        while (not BooGEOL) and (not BooGEOF) do begin
            BooGEOF := (InsGInstream.Read(ChaGTmp, 1) = 0);

            if (ChaGTmp = 10) or (ChaGTmp = 13) then
                BooGEOL := true
            else
                TxtGChaTab[i] := Format(ChaGTmp);
            i += 1;
            IntGLineSize += 1;
        end;

        if GuiAllowed then
            DiaGWin.Update(1, Round(IntGLineSize / IntGFileSize * 10000, 1));

        if not BooGEOF then begin
            IntGNbLine += 1;
            BooGEOF := (InsGInstream.Read(ChaGTmp, 1) = 0);
            if (ChaGTmp <> 13) and (ChaGTmp <> 10) then begin
                i := 1;
                TxtGChaTab[i] := Format(ChaGTmp);
                i += 1;
            end
            else
                i := 1;
        end;

        exit(BooGEOF);
    end;


    procedure FctRetreiveDatas(var TxtPBufferDatasTab: array[3000] of Text[1])
    begin
        CopyArray(TxtPBufferDatasTab, TxtGChaTab, 1);
    end;


    procedure FctRetreiveVarDatas(var TxtPBufferDatasTab: array[3000] of Text[1]; IntPValueIndex: Integer; CodPFieldSeparator: Code[10]; CodPFieldDelimiter: Code[10])
    var
        BooLFindValue: Boolean;
        ChaLSpaceReplace: Char;
        j: Integer;
        x: Integer;
    begin
        BooLFindValue := false;
        ChaLSpaceReplace := 231; //Replace Space in string value for involve compressarray to remove space in string
        j := 1;
        x := 1;
        IntPValueIndex -= 1;

        repeat
            if CodPFieldSeparator <> '' then
                if TxtGChaTab[j] = CodPFieldSeparator then begin
                    IntPValueIndex -= 1;
                    BooLFindValue := (IntPValueIndex = -1);
                end
                else
                    if (IntPValueIndex = 0) and (CodPFieldSeparator <> '') then
                        if TxtGChaTab[j] <> CodPFieldSeparator then begin
                            if TxtGChaTab[j] = ' ' then
                                TxtPBufferDatasTab[x] := Format(ChaLSpaceReplace)
                            else
                                TxtPBufferDatasTab[x] := TxtGChaTab[j];

                            x += 1;
                            if (j > 1) and
                               (j < 3000) then begin
                                if ((CodPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = CodPFieldDelimiter)) and
                                   ((TxtGChaTab[j - 1] = CodPFieldSeparator) or
                                    (TxtGChaTab[j - 1] = '') or
                                    (TxtGChaTab[j + 1] = CodPFieldSeparator)) then
                                    x -= 1;
                            end
                            else
                                if ((CodPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = CodPFieldDelimiter)) then
                                    x -= 1;
                        end;
            j += 1;
        until (BooLFindValue) or (j > ArrayLen(TxtGChaTab));

        if (CodPFieldDelimiter <> '') then
            if (TxtGChaTab[j - 1] = '') or
               (TxtGChaTab[j - 1] = CodPFieldDelimiter) then
                TxtPBufferDatasTab[x] := '';

        CompressArray(TxtPBufferDatasTab);
    end;


    procedure FctRetreiveFixDatas(var TxtPBufferDatasTab: array[3000] of Text[1]; IntPPosition: Integer; IntPLength: Integer)
    var
        j: Integer;
        x: Integer;
    begin
        x := 1;
        for j := IntPPosition to (IntPPosition + IntPLength - 1) do begin
            TxtPBufferDatasTab[x] := TxtGChaTab[j];
            x += 1;
        end;
        CompressArray(TxtPBufferDatasTab);
    end;


    procedure FctReturnRetreiveVarDatas(IntPValueIndex: Integer; CodPFieldSeparator: Code[10]; CodPFieldDelimiter: Code[10]): Text[250]
    var
        BooLFindValue: Boolean;
        ChaLSpaceReplace: Char;
        j: Integer;
        x: Integer;
        TxtLVal: Text[250];
    begin
        TxtLVal := '';
        BooLFindValue := false;
        ChaLSpaceReplace := 231; //Replace Space in string value for involve compressarray to remove space in string
        j := 1;
        x := 1;
        IntPValueIndex -= 1;

        repeat
            if CodPFieldSeparator <> '' then
                if TxtGChaTab[j] = CodPFieldSeparator then begin
                    IntPValueIndex -= 1;
                    BooLFindValue := (IntPValueIndex = -1);
                end
                else
                    if (IntPValueIndex = 0) and (CodPFieldSeparator <> '') then
                        if TxtGChaTab[j] <> CodPFieldSeparator then begin
                            if TxtGChaTab[j] = Format(ChaLSpaceReplace) then
                                TxtLVal += ' '
                            else
                                TxtLVal += TxtGChaTab[j];

                            if (j > 1) and
                               (j < 1500) then begin
                                if ((CodPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = CodPFieldDelimiter)) and
                                   ((TxtGChaTab[j - 1] = CodPFieldSeparator) or
                                    (TxtGChaTab[j - 1] = '') or
                                    (TxtGChaTab[j + 1] = CodPFieldSeparator)) then
                                    TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);
                            end
                            else
                                if ((CodPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = CodPFieldDelimiter)) then
                                    TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);
                        end;
            j += 1;
        until (BooLFindValue) or (j > ArrayLen(TxtGChaTab));

        if (CodPFieldDelimiter <> '') then
            if (TxtGChaTab[j - 1] = '') or
               (TxtGChaTab[j - 1] = CodPFieldDelimiter) then
                TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);

        exit(DelChr(TxtLVal, '<>', ' '));
    end;


    procedure FctReturnRetreiveVarDatas2(IntPValueIndex: Integer; txtPFieldSeparator: Text[10]; TxtPFieldDelimiter: Text[10]): Text[250]
    var
        BooLFindValue: Boolean;
        ChaLSpaceReplace: Char;
        j: Integer;
        x: Integer;
        TxtLVal: Text[250];
    begin
        TxtLVal := '';
        BooLFindValue := false;
        ChaLSpaceReplace := 231; //Replace Space in string value for involve compressarray to remove space in string
        j := 1;
        x := 1;
        IntPValueIndex -= 1;

        repeat
            if txtPFieldSeparator <> '' then
                if TxtGChaTab[j] = txtPFieldSeparator then begin
                    IntPValueIndex -= 1;
                    BooLFindValue := (IntPValueIndex = -1);
                end
                else
                    if (IntPValueIndex = 0) and (txtPFieldSeparator <> '') then
                        if TxtGChaTab[j] <> txtPFieldSeparator then begin
                            if TxtGChaTab[j] = Format(ChaLSpaceReplace) then
                                TxtLVal += ' '
                            else
                                TxtLVal += TxtGChaTab[j];

                            if (j > 1) and
                               (j < 1500) then begin
                                if ((TxtPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = TxtPFieldDelimiter)) and
                                   ((TxtGChaTab[j - 1] = txtPFieldSeparator) or
                                    (TxtGChaTab[j - 1] = '') or
                                    (TxtGChaTab[j + 1] = txtPFieldSeparator)) then
                                    TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);
                            end
                            else
                                if ((TxtPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = TxtPFieldDelimiter)) then
                                    TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);
                        end;
            j += 1;
        until (BooLFindValue) or (j > ArrayLen(TxtGChaTab));

        if (TxtPFieldDelimiter <> '') then
            if (TxtGChaTab[j - 1] = '') or
               (TxtGChaTab[j - 1] = TxtPFieldDelimiter) then
                TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);

        exit(DelChr(TxtLVal, '<>', ' '));
    end;


    procedure FctReturnRetreiveFixDatas(IntPPosition: Integer; IntPLength: Integer; BooPDelSpace: Boolean): Text[250]
    var
        j: Integer;
        TxtLVal: Text[250];
    begin
        TxtLVal := '';
        for j := IntPPosition to (IntPPosition + IntPLength - 1) do
            TxtLVal += TxtGChaTab[j];
        if BooPDelSpace then
            exit(DelChr(TxtLVal, '<>', ' '))
        else
            exit(TxtLVal);
    end;


    procedure FctReturnRetreiveFixDatas2(IntPPosition: Integer; IntPLength: Integer): Text[250]
    var
        j: Integer;
        TxtLVal: Text[250];
    begin
        TxtLVal := '';
        for j := IntPPosition to (IntPPosition + IntPLength - 1) do
            TxtLVal += TxtGChaTab[j];
        exit(TxtLVal);
    end;


    procedure FctReturnRetreiveVarDatas3(IntPValueIndex: Integer; txtPFieldSeparator: Text[10]; TxtPFieldDelimiter: Text[10]): Text[250]
    var
        BooLFindValue: Boolean;
        ChaLSpaceReplace: Char;
        j: Integer;
        x: Integer;
        TxtLVal: Text[250];
    begin
        TxtLVal := '';
        BooLFindValue := false;
        ChaLSpaceReplace := 231; //Replace Space in string value for involve compressarray to remove space in string
        j := 1;
        x := 1;
        IntPValueIndex -= 1;

        repeat
            if txtPFieldSeparator <> '' then
                if TxtGChaTab[j] = txtPFieldSeparator then begin
                    IntPValueIndex -= 1;
                    BooLFindValue := (IntPValueIndex = -1);
                end
                else
                    if (IntPValueIndex = 0) and (txtPFieldSeparator <> '') then
                        if TxtGChaTab[j] <> txtPFieldSeparator then begin
                            if TxtGChaTab[j] = Format(ChaLSpaceReplace) then
                                TxtLVal += ' '
                            else
                                TxtLVal += TxtGChaTab[j];

                            if (j > 1) and
                               (j < 1500) then begin
                                if ((TxtPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = TxtPFieldDelimiter)) and
                                   ((TxtGChaTab[j - 1] = txtPFieldSeparator) or
                                    (TxtGChaTab[j - 1] = '') or
                                    (TxtGChaTab[j + 1] = txtPFieldSeparator)) then
                                    TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);
                            end
                            else
                                if ((TxtPFieldDelimiter <> '') and
                                    (TxtGChaTab[j] = TxtPFieldDelimiter)) then
                                    TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);
                        end;
            j += 1;
        until (BooLFindValue) or (j > ArrayLen(TxtGChaTab));

        if (TxtPFieldDelimiter <> '') then
            if (TxtGChaTab[j - 1] = '') or
               (TxtGChaTab[j - 1] = TxtPFieldDelimiter) then
                TxtLVal := CopyStr(TxtLVal, 1, StrLen(TxtLVal) - 1);

        exit(TxtLVal);
    end;


    procedure FctCreateBufferDatas(TxtPValue: Text[250]; CodPFieldSeparator: Code[10]; CodPFieldDelimiter: Code[10]; IntPFixLength: Integer; TxtPCompChar: Text[1]; CodPSens: Text[1])
    var
        ChaLSpaceReplace: Char;
        j: Integer;
        TxtLComp: Text[250];
    begin
        ChaLSpaceReplace := 231;

        if IntPFixLength > 0 then begin
            TxtLComp := '';
            for j := 1 to (IntPFixLength - StrLen(TxtPValue)) do
                TxtLComp += TxtPCompChar;
            if CodPSens = '<' then
                TxtPValue := TxtLComp + TxtPValue
            else
                TxtPValue += TxtLComp;
        end;

        if CodPFieldDelimiter <> '' then begin
            TxtGChaTab2[i] := Format(CodPFieldDelimiter);
            i += 1;
        end;

        for j := 1 to StrLen(TxtPValue) do begin
            if TxtPValue[j] = ' ' then
                TxtGChaTab2[i] := Format(ChaLSpaceReplace)
            else
                TxtGChaTab2[i] := Format(TxtPValue[j]);
            i += 1;
        end;

        if CodPFieldDelimiter <> '' then
            TxtGChaTab2[i] := Format(CodPFieldDelimiter);

        if CodPFieldSeparator <> '' then begin
            if CodPFieldDelimiter <> '' then
                i += 1;
            TxtGChaTab2[i] := Format(CodPFieldSeparator);
            i += 1;
        end;
    end;


    procedure FctWriteLine(BooPLF: Boolean; BooPCR: Boolean; CodPFieldSeparator: Code[10]): Boolean
    var
        ChaLLForCR: Char;
        ChaLSpaceReplace: Char;
        IntLTotalElement: Integer;
        j: Integer;
    begin
        IntLTotalElement := CompressArray(TxtGChaTab2);
        ChaLSpaceReplace := 231;
        if CodPFieldSeparator <> '' then
            for j := 1 to IntLTotalElement - 1 do
                if TxtGChaTab2[j] = Format(ChaLSpaceReplace) then
                    OusGOustream.WriteText(Format(' '))
                else
                    OusGOustream.WriteText(Format(TxtGChaTab2[j]))
        else
            for j := 1 to IntLTotalElement do
                if TxtGChaTab2[j] = Format(ChaLSpaceReplace) then
                    OusGOustream.WriteText(Format(' '))
                else
                    OusGOustream.WriteText(Format(TxtGChaTab2[j]));
        OusGOustream.WriteText('');

        if BooPLF then begin
            ChaLLForCR := 13;
            OusGOustream.WriteText(Format(ChaLLForCR));
        end;
        if BooPCR then begin
            ChaLLForCR := 10;
            OusGOustream.WriteText(Format(ChaLLForCR));
        end;

        Clear(TxtGChaTab2);
        i := 1;
    end;


    procedure FctWriteLineDirect(TxtPValue: Text[250]; CodPFieldSeparator: Code[10]; CodPFieldDelimiter: Code[10]; IntPFixLength: Integer; TxtPCompChar: Text[1]; CodPSens: Text[1]; BooPLF: Boolean; BooPCR: Boolean): Boolean
    var
        ChaLLForCR: Char;
        ChaLSpaceReplace: Char;
        j: Integer;
        TxtLComp: Text[250];
    begin
        ChaLSpaceReplace := 231;

        if IntPFixLength > 0 then begin
            TxtLComp := '';
            for j := 1 to (IntPFixLength - StrLen(TxtPValue)) do
                TxtLComp += TxtPCompChar;
            if CodPSens = '<' then
                TxtPValue := TxtLComp + TxtPValue
            else
                TxtPValue += TxtLComp;
        end;

        if CodPFieldDelimiter <> '' then
            TxtPValue := Format(CodPFieldDelimiter) + TxtPValue + Format(CodPFieldDelimiter);

        if CodPFieldSeparator <> '' then
            TxtPValue += Format(CodPFieldSeparator);

        if (BooPCR) and
           (CodPFieldSeparator <> '') then
            OusGOustream.WriteText(Format(CopyStr(TxtPValue, 1, StrLen(TxtPValue) - 1)))
        else
            OusGOustream.WriteText(Format(TxtPValue));
        OusGOustream.WriteText('');

        if BooPLF then begin
            ChaLLForCR := 13;
            OusGOustream.WriteText(Format(ChaLLForCR));
        end;
        if BooPCR then begin
            ChaLLForCR := 10;
            OusGOustream.WriteText(Format(ChaLLForCR));
        end;
    end;


    procedure FctRetreiveFileSize(): Integer
    begin
        exit(FilGFile.Len);
    end;


    procedure FctRetreiveLineSize(): Integer
    begin
        exit(IntGLineSize);
    end;


    procedure FctCloseFile()
    begin
        if GuiAllowed then
            DiaGWin.Close();

        FilGFile.Close();
    end;


    procedure FctCloseWriteFile()
    begin
        FilGFile.Close();
    end;


    procedure FctOpenFileToModify(TxtPFileName: Text[250])
    begin
        FilGFile.TextMode(false);
        FilGFile.WriteMode(true);
        FilGFile.Open(TxtPFileName);
        IntGNbLine := 0;
        i := 1;
        FilGFile.CreateInStream(InsGInstream);
        FilGFile.CreateOutStream(OusGOustream);
        BooGEOF := false;

        if GuiAllowed then begin
            DiaGWin.Open(CstG001);
            IntGFileSize := FctRetreiveFileSize();
            IntGLineSize := 0;
        end;
    end;


    procedure FctModifyLineDirect(TxtPValue: Text[250]; CodPFieldSeparator: Code[10]; CodPFieldDelimiter: Code[10]; IntPBegin: Integer; IntPFixLength: Integer; TxtPCompChar: Text[1]; CodPSens: Text[1]; BooPLF: Boolean; BooPCR: Boolean): Boolean
    var
        ChaLLForCR: Char;
        ChaLSpaceReplace: Char;
        i: Integer;
        TxtLValue: Text[250];
    begin
        ChaLSpaceReplace := 231;

        if IntPBegin > 0 then begin
            TxtLValue := CopyStr(FctReturnRetreiveVarDatas(1, CodPFieldSeparator, CodPFieldDelimiter), 1, IntPBegin - 1);
            for i := 1 to IntPFixLength do
                TxtLValue += TxtPValue;
        end;
        TxtPValue := TxtLValue;


        if CodPFieldDelimiter <> '' then
            TxtPValue := Format(CodPFieldDelimiter) + TxtPValue + Format(CodPFieldDelimiter);

        if CodPFieldSeparator <> '' then
            TxtPValue += Format(CodPFieldSeparator);

        if (BooPCR) and
           (CodPFieldSeparator <> '') then
            OusGOustream.WriteText(Format(CopyStr(TxtPValue, 1, StrLen(TxtPValue) - 1)))
        else
            OusGOustream.WriteText(Format(TxtPValue));
        OusGOustream.WriteText('');

        if BooPLF then begin
            ChaLLForCR := 13;
            OusGOustream.WriteText(Format(ChaLLForCR));
        end;
        if BooPCR then begin
            ChaLLForCR := 10;
            OusGOustream.WriteText(Format(ChaLLForCR));
        end;
    end;


    procedure FctOpenFile2()
    begin
        FilGFile.TextMode(false);
        FilGFile.Open(TxtGFileName);
        IntGNbLine := 0;
        i := 1;
        FilGFile.CreateInStream(InsGInstream);
        BooGEOF := false;

        if GuiAllowed then begin
            DiaGWin.Open(CstG001);
            IntGFileSize := FctRetreiveFileSize();
            IntGLineSize := 0;
        end;
    end;


    procedure FctInitFileName(TxtPFileName: Text[250])
    begin
        TxtGFileName := TxtPFileName;
    end;


    procedure FctDefineSeparatorAndDelemiter(var RecPConnectorValues: Record "PWD Connector Values")
    begin
        CodGFieldSeparator := RecPConnectorValues.Separator;
        CodGFieldDelimiter := '';
        OptGFileType := RecPConnectorValues."File format";

        if OptGFileType = OptGFileType::Xml then
            Error(CstG002);
    end;


    procedure FctReturnVarData(IntPIndexField: Integer): Text[250]
    begin
        exit(FctReturnRetreiveVarDatas3(IntPIndexField, CodGFieldSeparator, CodGFieldDelimiter));
    end;


    procedure FctReturnFixData(IntPBeginPosiField: Integer; IntPLenghtField: Integer): Text[250]
    begin
        exit(FctReturnRetreiveFixDatas2(IntPBeginPosiField, IntPLenghtField));
    end;
}

