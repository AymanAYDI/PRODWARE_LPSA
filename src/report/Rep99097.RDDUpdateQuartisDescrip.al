report 99097 "RDD - Update Quartis Descrip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdl/RDDUpdateQuartisDescrip.rdl';

    dataset
    {
        dataitem("PWD Item Configurator"; "PWD Item Configurator")
        {
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

    labels
    {
    }


    procedure FctConfigDescStone(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLDim1: Text[30];
        TxtLDim2: Text[30];
    begin
        with RecPItemConfigurator do begin
            TxtLDim1 := Format(Hole);
            TxtLDim2 := Format("External Diameter");
            TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
            TxtLDim2 := CopyStr(TxtLDim2, 1, StrPos(TxtLDim2, ',') + 1);
            "PWD Quartis Description" := "Piece Type Stone" + '-' + TxtLDim1 + '-' + TxtLDim2 + '-' + Format(Thickness);
        end;
    end;


    procedure FctConfigDescPrepa(var RecPItemConfigurator: Record "PWD Item Configurator")
    begin
        with RecPItemConfigurator do begin
            "PWD Quartis Description" := "Piece Type Preparage" + '-';
            if "Piece Type Preparage" in ['CARRELET', 'ENTRETOISE'] then begin
                if (("Width Min." <> 0) or ("Width Max." <> 0)) then
                    if "Width Min." = "Width Max." then
                        "PWD Quartis Description" := "PWD Quartis Description" + 'L' + '-/+' + Format("Width Max.")
                    else
                        "PWD Quartis Description" := "PWD Quartis Description" + 'L-' + Format("Width Min.") + '/+' + Format("Width Max.");
                if (("Height Min." <> 0) or ("Height Max." <> 0)) then
                    if "Height Min." = "Height Max." then
                        "PWD Quartis Description" := "PWD Quartis Description" + 'H' + '+/-' + Format("Height Max.")
                    else
                        "PWD Quartis Description" := "PWD Quartis Description" + 'H-' + Format("Height Min.") + '/+' + Format("Height Max.");
                if (("Width / Depth Min." <> 0) or ("Width / Depth Max." <> 0)) then
                    if "Width / Depth Min." = "Width / Depth Max." then
                        "PWD Quartis Description" := "PWD Quartis Description" + 'P' + '+/-' + Format("Width / Depth Max.")
                    else
                        "PWD Quartis Description" := "PWD Quartis Description" + 'P-' + Format("Width / Depth Min.") + '/+' + Format("Width / Depth Max.")
                ;
            end else
                if "Piece Type Preparage" in ['CHEVILLE', 'GOUPILLE'] then begin
                    if (("Diameter Min." <> 0) or ("Diameter Max." <> 0)) then
                        if "Diameter Min." = "Diameter Max." then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'D' + '+/-' + Format("Diameter Max.")
                        else
                            "PWD Quartis Description" := "PWD Quartis Description" + 'D-' + Format("Diameter Min.") + '/+' + Format("Diameter Max.");
                    if (("Width / Depth Min." <> 0) or ("Width / Depth Max." <> 0)) then
                        if "Width / Depth Min." = "Width / Depth Max." then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'L' + '+/-' + Format("Width / Depth Max.")
                        else
                            "PWD Quartis Description" := "PWD Quartis Description" + 'L-' + Format("Width / Depth Min.") + '/+' + Format("Width / Depth Max.")
                    ;
                end else begin
                    if (("Piercing Min." <> 0) or ("Piercing Max." <> 0)) then
                        if "Piercing Min." = "Piercing Max." then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'T' + '+/-' + Format("Piercing Max.")
                        else
                            "PWD Quartis Description" := "PWD Quartis Description" + 'T-' + Format("Piercing Min.") + '/+' + Format("Piercing Max.");
                    if Note <> 0 then
                        "PWD Quartis Description" := "PWD Quartis Description" + '(' + Format(Note) + ')';
                    if (("Diameter Min." <> 0) or ("Diameter Max." <> 0)) then
                        if "Diameter Min." = "Diameter Max." then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'x D' + '+/-' + Format("Diameter Max.")
                        else
                            "PWD Quartis Description" := "PWD Quartis Description" + 'x D-' + Format("Diameter Min.") + '/+' + Format("Diameter Max.");
                    if ("Thick Min." <> 0) or ("Thick Max." <> 0) then
                        if "Thick Min." = "Thick Max." then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'x E' + '+/-' + Format("Thick Max.")
                        else
                            "PWD Quartis Description" := "PWD Quartis Description" + 'x E-' + Format("Thick Min.") + '/+' + Format("Thick Max.");
                end;
        end;
    end;


    procedure FctConfigDescLifted(var RecPItemConfigurator: Record "PWD Item Configurator")
    begin
        with RecPItemConfigurator do begin
            "PWD Quartis Description" := "Piece Type Lifted&Ellipses" + '-';
            if "Piece Type Lifted&Ellipses" = 'LEVEES' then begin
                if (Angle <> 0) then
                    "PWD Quartis Description" := "PWD Quartis Description" + 'A' + Format(Angle);
                if ("Height Tol" <> 0) then
                    "PWD Quartis Description" := "PWD Quartis Description" + 'H' + Format("Height Tol");
                if ("Thick Tol" <> 0) then
                    "PWD Quartis Description" := "PWD Quartis Description" + 'E' + Format("Thick Tol");
                if ("Lg Tol" <> 0) then
                    "PWD Quartis Description" := "PWD Quartis Description" + 'L' + Format("Lg Tol");
            end else
                if "Piece Type Lifted&Ellipses" in ['ELLIPSES', 'PLAT POLI'] then begin
                    if ("Diameter Tol" <> 0) then
                        "PWD Quartis Description" := "PWD Quartis Description" + 'D' + Format("Diameter Tol");
                    if ("Thick Tol" <> 0) then
                        "PWD Quartis Description" := "PWD Quartis Description" + 'P' + Format("Thick Tol");
                    if ("Lg Tol" <> 0) then
                        "PWD Quartis Description" := "PWD Quartis Description" + 'L' + Format("Lg Tol");
                end else
                    if "Piece Type Lifted&Ellipses" in ['GOUPILLE', 'CHEVILLE'] then begin
                        if ("Diameter Tol" <> 0) then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'D' + Format("Diameter Tol");
                        if ("Lg Tol" <> 0) then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'L' + Format("Lg Tol");
                    end else begin
                        if ("Thick Tol" <> 0) then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'L' + Format("Thick Tol");
                        if ("Height Tol" <> 0) then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'H' + Format("Height Tol");
                        if ("Lg Tol" <> 0) then
                            "PWD Quartis Description" := "PWD Quartis Description" + 'P' + Format("Lg Tol");
                    end;
        end;
    end;


    procedure FctConfigDescSemiFinish(var RecPItemConfigurator: Record "PWD Item Configurator")
    var
        TxtLDim1: Text[30];
    begin
        with RecPItemConfigurator do
            if "Piece Type Semi-finished" = 'GRANDI' then begin
                TxtLDim1 := Format("Hole Tol");
                TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
                "PWD Quartis Description" := "Piece Type Semi-finished" + '-' + TxtLDim1 + '(-' + Format("Hole Tol Min.") + '/+' +
                                          Format("Hole Tol Max.") + '-(-' + Format("D Min.") + '/+' + Format("D Max.") + ')-(-' +
                                          Format("Ep Min.") + '/+' + Format("Ep Max.") + ')';
            end else begin
                TxtLDim1 := Format("External Diameter Tol");
                TxtLDim1 := CopyStr(TxtLDim1, 1, StrPos(TxtLDim1, ',') + 1);
                "PWD Quartis Description" := "Piece Type Semi-finished" + '-' + Format("Hole Tol") + '(-' + Format("Hole Tol Min.") + '/+' +
                                          Format("Hole Tol Max.") + ')-' + TxtLDim1 + '-' + '(-' + Format("Ep Min.") +
                                          '/+' + Format("Ep Max.") + ')';

            end;
    end;
}

