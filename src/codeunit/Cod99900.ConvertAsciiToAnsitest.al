codeunit 99900 "PWD Convert Ascii To Ansi test"
{
    // +----------------------------------------------------------------------------------------------------------------+
    // | ProdWare - Pôle Expertise Edition                                                                              |
    // | www.prodware.fr                                                          ,                                      |
    // +----------------------------------------------------------------------------------------------------------------+
    // 
    // //>>ProdConnect.1.00
    // 
    // FE_ProdConnect.001:GR 22/03/2011  Connector integration
    //                                   - Create Object
    // 
    // //>>LAP2.14
    //  RO : 14/03/2018 : Nouvelles demande Export Prod Order remis à plat
    //                    Modif property Dimensions for C/AL GLobal Translations
    //                    Add C/AL Code in triggers InitConversionArray
    //                                              AsciiToAnsi
    //                                              AnsiToAscii
    // +----------------------------------------------------------------------------------------------------------------+


    trigger OnRun()
    var
        T27: Record Item;
        textlower: Text[30];
    begin
        T27.Get('99510007');
        textlower := LowerCase(T27.Description);
        Message('désignation %1 > %4 => %2 > %3',
        T27.Description, AsciiToAnsi(T27.Description), AsciiToAnsi(textlower), LowerCase(T27.Description));
    end;

    var
        Found: Boolean;
        Translations: array[150, 2] of Char;
        i: Integer;
        pos: Integer;


    procedure AsciiToAnsi(var TextAscii: Text[250]) TextAnsi: Text[250]
    begin
        InitConversionArray();
        TextAnsi := TextAscii;
        for pos := 1 to StrLen(TextAscii) do
            if (TextAnsi[pos] > 127) then begin                      //different chars after 127
                i := 0;
                Found := false;
                //>>LAP2.14
                //    WHILE ( (Found = FALSE) AND (i < 84) ) DO BEGIN       //array of 83 elements
                while ((Found = false) and (i < 151)) do begin       //array of 150 elements
                                                                     //<<LAP2.14
                    i += 1;
                    if (Translations[i] [1] = TextAnsi[pos]) then begin
                        Found := true;
                        TextAnsi[pos] := Translations[i] [2];
                    end;
                end;
                Message('found %1 i %2 Pos %3', Found, i, pos);
            end;
    end;


    procedure AnsiToAscii(var TextAnsi: Text[250]) TextAscii: Text[250]
    begin
        InitConversionArray();
        TextAscii := TextAnsi;
        for pos := 1 to StrLen(TextAscii) do
            if (TextAscii[pos] > 127) then begin                     //different chars after 127
                i := 0;
                Found := false;
                //>>LAP2.14
                //    WHILE ( (Found = FALSE) AND (i < 84) ) DO BEGIN       //array of 83 elements
                while ((Found = false) and (i < 86)) do begin       //array of 85 elements
                                                                    //<<LAP2.14
                    i += 1;
                    if (Translations[i] [2] = TextAscii[pos]) then begin
                        Found := true;
                        TextAscii[pos] := Translations[i] [1];
                    end;
                end;
            end;
    end;


    procedure InitConversionArray()
    begin
        /*Ç*/
        Translations[1] [1] := 128;
        Translations[1] [2] := 199;
        /*ü*/
        Translations[2] [1] := 129;
        Translations[2] [2] := 252;
        /*é*/
        Translations[3] [1] := 130;
        Translations[3] [2] := 233;
        /*â*/
        Translations[4] [1] := 131;
        Translations[4] [2] := 226;
        /*ä*/
        Translations[5] [1] := 132;
        Translations[5] [2] := 228;
        /*à*/
        Translations[6] [1] := 133;
        Translations[6] [2] := 224;
        /*å*/
        Translations[7] [1] := 134;
        Translations[7] [2] := 229;
        /*ç*/
        Translations[8] [1] := 135;
        Translations[8] [2] := 231;
        /*ê*/
        Translations[9] [1] := 136;
        Translations[9] [2] := 234;
        /*ë*/
        Translations[10] [1] := 137;
        Translations[10] [2] := 235;
        /*è*/
        Translations[11] [1] := 138;
        Translations[11] [2] := 232;
        /*ï*/
        Translations[12] [1] := 139;
        Translations[12] [2] := 239;
        /*î*/
        Translations[13] [1] := 140;
        Translations[13] [2] := 238;
        /*ì*/
        Translations[14] [1] := 141;
        Translations[14] [2] := 236;
        /*Ä*/
        Translations[15] [1] := 142;
        Translations[15] [2] := 196;
        /*Å*/
        Translations[16] [1] := 143;
        Translations[16] [2] := 197;
        /*É*/
        Translations[17] [1] := 144;
        Translations[17] [2] := 201;
        /*æ*/
        Translations[18] [1] := 145;
        Translations[18] [2] := 230;
        /*Æ*/
        Translations[19] [1] := 146;
        Translations[19] [2] := 198;
        /*ô*/
        Translations[20] [1] := 147;
        Translations[20] [2] := 244;
        /*ö*/
        Translations[21] [1] := 148;
        Translations[21] [2] := 246;
        /*ò*/
        Translations[22] [1] := 149;
        Translations[22] [2] := 242;
        /*û*/
        Translations[23] [1] := 150;
        Translations[23] [2] := 251;
        /*ù*/
        Translations[24] [1] := 151;
        Translations[24] [2] := 249;
        /*Ö*/
        Translations[25] [1] := 153;
        Translations[25] [2] := 214;
        /*Ü*/
        Translations[26] [1] := 154;
        Translations[26] [2] := 220;
        /*£*/
        Translations[27] [1] := 156;
        Translations[27] [2] := 163;
        /*á*/
        Translations[28] [1] := 160;
        Translations[28] [2] := 225;
        /*í*/
        Translations[29] [1] := 161;
        Translations[29] [2] := 237;
        /*ó*/
        Translations[30] [1] := 162;
        Translations[30] [2] := 243;
        /*ú*/
        Translations[31] [1] := 163;
        Translations[31] [2] := 250;
        /*ñ*/
        Translations[32] [1] := 164;
        Translations[32] [2] := 241;
        /*Ñ*/
        Translations[33] [1] := 165;
        Translations[33] [2] := 209;
        /*¿*/
        Translations[34] [1] := 168;
        Translations[34] [2] := 191;
        /*®*/
        Translations[35] [1] := 169;
        Translations[35] [2] := 174;
        /*½*/
        Translations[36] [1] := 171;
        Translations[36] [2] := 189;
        /*¼*/
        Translations[37] [1] := 172;
        Translations[37] [2] := 188;
        /*¡*/
        Translations[38] [1] := 173;
        Translations[38] [2] := 161;
        /*«*/
        Translations[39] [1] := 174;
        Translations[39] [2] := 171;
        /*»*/
        Translations[40] [1] := 175;
        Translations[40] [2] := 187;
        /*Á*/
        Translations[41] [1] := 181;
        Translations[41] [2] := 193;
        /*Â*/
        Translations[42] [1] := 182;
        Translations[42] [2] := 194;
        /*À*/
        Translations[43] [1] := 183;
        Translations[43] [2] := 192;
        /*©*/
        Translations[44] [1] := 184;
        Translations[44] [2] := 169;
        /*¢*/
        Translations[45] [1] := 189;
        Translations[45] [2] := 162;
        /*¥*/
        Translations[46] [1] := 190;
        Translations[46] [2] := 165;
        /*ã*/
        Translations[47] [1] := 198;
        Translations[47] [2] := 227;
        /*Ã*/
        Translations[48] [1] := 199;
        Translations[48] [2] := 195;
        /*¤*/
        Translations[49] [1] := 207;
        Translations[49] [2] := 164;
        /*ð*/
        Translations[50] [1] := 208;
        Translations[50] [2] := 240;
        /*Ð*/
        Translations[51] [1] := 209;
        Translations[51] [2] := 208;
        /*Ê*/
        Translations[52] [1] := 210;
        Translations[52] [2] := 202;
        /*Ë*/
        Translations[53] [1] := 211;
        Translations[53] [2] := 203;
        /*È*/
        Translations[54] [1] := 212;
        Translations[54] [2] := 200;
        /*Í*/
        Translations[55] [1] := 214;
        Translations[55] [2] := 205;
        /*Î*/
        Translations[56] [1] := 215;
        Translations[56] [2] := 206;
        /*Ï*/
        Translations[57] [1] := 216;
        Translations[57] [2] := 207;
        /*Ì*/
        Translations[58] [1] := 222;
        Translations[58] [2] := 204;
        /*Ó*/
        Translations[59] [1] := 224;
        Translations[59] [2] := 211;
        /*ß*/
        Translations[60] [1] := 225;
        Translations[60] [2] := 223;
        /*Ô*/
        Translations[61] [1] := 226;
        Translations[61] [2] := 212;
        /*Ò*/
        Translations[62] [1] := 227;
        Translations[62] [2] := 210;
        /*õ*/
        Translations[63] [1] := 228;
        Translations[63] [2] := 245;
        /*Õ*/
        Translations[64] [1] := 229;
        Translations[64] [2] := 213;
        /*µ*/
        Translations[65] [1] := 230;
        Translations[65] [2] := 181;
        /*þ*/
        Translations[66] [1] := 231;
        Translations[66] [2] := 222;
        /*Þ*/
        Translations[67] [1] := 232;
        Translations[67] [2] := 254;
        /*Ú*/
        Translations[68] [1] := 233;
        Translations[68] [2] := 218;
        /*Û*/
        Translations[69] [1] := 234;
        Translations[69] [2] := 219;
        /*Ù*/
        Translations[70] [1] := 235;
        Translations[70] [2] := 217;
        /*ý*/
        Translations[71] [1] := 236;
        Translations[71] [2] := 253;
        /*Ý*/
        Translations[72] [1] := 237;
        Translations[72] [2] := 221;
        /*´*/
        Translations[73] [1] := 239;
        Translations[73] [2] := 180;
        /*±*/
        Translations[74] [1] := 241;
        Translations[74] [2] := 177;
        /*¾*/
        Translations[75] [1] := 243;
        Translations[75] [2] := 190;
        /*¶*/
        Translations[76] [1] := 244;
        Translations[76] [2] := 182;
        /*§*/
        Translations[77] [1] := 245;
        Translations[77] [2] := 167;
        /*°*/
        Translations[78] [1] := 248;
        Translations[78] [2] := 176;
        /*¨*/
        Translations[79] [1] := 249;
        Translations[79] [2] := 168;
        /*·*/
        Translations[80] [1] := 250;
        Translations[80] [2] := 183;
        /*¹*/
        Translations[81] [1] := 251;
        Translations[81] [2] := 185;
        /*³*/
        Translations[82] [1] := 252;
        Translations[82] [2] := 179;
        /*²*/
        Translations[83] [1] := 253;
        Translations[83] [2] := 178;
        //>>LAP2.14
        //{¯} Translations[84][1] := 238; Translations[84][2] := 140;
        /*¯*/
        Translations[84] [1] := 238;
        Translations[84] [2] := 216;
        /*¯*/
        Translations[85] [1] := 157;
        Translations[85] [2] := 216;
        /**/
        Translations[86] [1] := 152;
        Translations[85] [2] := 216;
        /**/
        Translations[87] [1] := 155;
        Translations[85] [2] := 216;
        /**/
        Translations[88] [1] := 157;
        Translations[85] [2] := 216;
        /**/
        Translations[89] [1] := 158;
        Translations[85] [2] := 216;
        /**/
        Translations[90] [1] := 159;
        Translations[85] [2] := 216;
        /**/
        Translations[91] [1] := 166;
        Translations[85] [2] := 216;
        /**/
        Translations[92] [1] := 167;
        Translations[85] [2] := 216;
        /**/
        Translations[93] [1] := 170;
        Translations[85] [2] := 216;
        /**/
        Translations[94] [1] := 176;
        Translations[85] [2] := 216;
        /**/
        Translations[95] [1] := 177;
        Translations[85] [2] := 216;
        /**/
        Translations[96] [1] := 178;
        Translations[85] [2] := 216;
        /**/
        Translations[97] [1] := 179;
        Translations[85] [2] := 216;
        /**/
        Translations[98] [1] := 180;
        Translations[85] [2] := 216;
        /**/
        Translations[99] [1] := 185;
        Translations[85] [2] := 216;
        /**/
        Translations[100] [1] := 186;
        Translations[85] [2] := 216;
        /**/
        Translations[101] [1] := 187;
        Translations[85] [2] := 216;
        /**/
        Translations[102] [1] := 188;
        Translations[85] [2] := 140;
        /**/
        Translations[103] [1] := 191;
        Translations[85] [2] := 216;
        /**/
        Translations[104] [1] := 192;
        Translations[85] [2] := 216;
        /**/
        Translations[105] [1] := 193;
        Translations[85] [2] := 216;
        /**/
        Translations[106] [1] := 194;
        Translations[85] [2] := 216;
        /**/
        Translations[107] [1] := 195;
        Translations[85] [2] := 216;
        /**/
        Translations[108] [1] := 196;
        Translations[85] [2] := 216;
        /**/
        Translations[109] [1] := 197;
        Translations[85] [2] := 216;
        /**/
        Translations[110] [1] := 200;
        Translations[85] [2] := 216;
        /**/
        Translations[111] [1] := 201;
        Translations[85] [2] := 216;
        /**/
        Translations[112] [1] := 202;
        Translations[85] [2] := 216;
        /**/
        Translations[113] [1] := 203;
        Translations[85] [2] := 216;
        /**/
        Translations[114] [1] := 204;
        Translations[85] [2] := 156;
        /**/
        Translations[115] [1] := 205;
        Translations[85] [2] := 216;
        /**/
        Translations[116] [1] := 206;
        Translations[85] [2] := 216;
        /**/
        Translations[117] [1] := 213;
        Translations[85] [2] := 216;
        /**/
        Translations[118] [1] := 217;
        Translations[85] [2] := 216;
        /**/
        Translations[119] [1] := 218;
        Translations[85] [2] := 216;
        /**/
        Translations[120] [1] := 219;
        Translations[85] [2] := 216;
        /**/
        Translations[121] [1] := 220;
        Translations[85] [2] := 216;
        /**/
        Translations[122] [1] := 221;
        Translations[85] [2] := 216;
        /**/
        Translations[123] [1] := 223;
        Translations[85] [2] := 216;
        /**/
        Translations[124] [1] := 238;
        Translations[85] [2] := 216;
        /**/
        Translations[125] [1] := 240;
        Translations[85] [2] := 216;
        /**/
        Translations[126] [1] := 242;
        Translations[85] [2] := 216;
        /**/
        Translations[127] [1] := 246;
        Translations[85] [2] := 216;
        /**/
        Translations[128] [1] := 247;
        Translations[85] [2] := 216;
        /**/
        Translations[129] [1] := 254;
        Translations[85] [2] := 216;
        /**/
        Translations[130] [1] := 255;
        Translations[85] [2] := 216;
        //<<LAP2.14

    end;
}

