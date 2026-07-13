report 50113 "Import Levy Transactions"
{
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; Integer)
        {

            trigger OnAfterGetRecord();
            begin
                RecNo := RecNo + 1;

                ExcelBuf.RESET;
                ExcelBuf.SETRANGE("Row No.", Number);
                ExcelBuf.SETFILTER("Cell Value as Text", '<>%1', '');
                IF ExcelBuf.FINDFIRST THEN BEGIN
                    if GetExcelCell(Number, 2) <> '' then begin
                        TempLevyComp.INIT;
                        TempLevyComp."Line No." := fn_TempLevyCompLineNo;
                        TempLevyComp."CS. NO" := GetExcelCell(Number, 1);
                        TempLevyComp."DT-NAME" := GetExcelCell(Number, 2);
                        TempLevyComp."CS. NO" := GetExcelCell(Number, 3);
                        TempLevyComp."TOTAL DEPOSITS" := GetExcelCellDecimal(Number, 4);
                        TempLevyComp."LEVY COMPUTATION" := GetExcelCellDecimal(Number, 5);
                        TempLevyComp."LEVY CAPPED" := GetExcelCellDecimal(Number, 6);
                        TempLevyComp.PERCENTAGE := 0.175;
                        //  TempLevyComp."LEVY COMPUTATION" := TempLevyComp."TOTAL DEPOSITS" * (TempLevyComp.PERCENTAGE / 100);

                        //  if TempLevyComp."LEVY COMPUTATION" > 10000000 then begin
                        //      TempLevyComp."LEVY CAPPED" := 10000000;
                        //   end else begin
                        //       TempLevyComp."LEVY CAPPED" := TempLevyComp."LEVY COMPUTATION";
                        //    end;

                        TempLevyComp.INSERT;
                    end;
                END;
            end;

            trigger OnPostDataItem();
            begin
                // MESSAGE('Process complete');
            end;

            trigger OnPreDataItem();
            begin

                ExcelBuf.RESET;
                ExcelBuf.SETFILTER("Row No.", '%1..', DataStartLineNo);
                IF ExcelBuf.FINDLAST THEN
                    TotalRecNo := ExcelBuf."Row No.";

                SETRANGE(Number, DataStartLineNo, TotalRecNo);

                TotalRecNo := ExcelBuf.COUNT;
                RecNo := 0;
            end;

        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Import From")
                    {
                        Caption = 'Import From';
                        field("Workbook File Name"; FileName)
                        {
                            Caption = 'Workbook File Name';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Workbook File Name field.';

                            trigger OnAssistEdit();
                            begin
                                RequestFile;
                                SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                            end;
                        }
                        field("Worksheet Name"; SheetName)
                        {
                            Caption = 'Worksheet Name';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the Worksheet Name field.';

                            trigger OnAssistEdit();
                            begin
                                IF ServerFileName = '' THEN
                                    RequestFile;

                                SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                            end;
                        }
                    }
                }
            }
        }

        actions { }
    }

    labels { }

    trigger OnInitReport();
    begin
        DataStartLineNo := 2;
        FileName := 'C:\Inbound\Sacco Societies Regulatory Authority\Supervision - Levies\Levy Computation and Capped.xlsx';
        ServerFileName := 'C:\Inbound\Sacco Societies Regulatory Authority\Supervision - Levies\Levy Computation and Capped.xlsx';
        SheetName := 'Levy Computation and Capped';
    end;

    trigger OnPostReport();
    begin
        //ExcelBuf.DELETEALL;
    end;

    trigger OnPreReport();
    begin
        ReadExcelSheet(ServerFileName, SheetName);
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        FileMgt: Codeunit "File Management";
        FileName: Text;
        ServerFileName: Text;
        SheetName: Text;
        DataStartLineNo: Integer;
        TotalRecNo: Integer;
        RecNo: Integer;
        TempLevyComp: Record "Temp Levy Computations";
        Text001: Label '" Import Excel File"';
        Text002: Label '" You must enter a file name."';

    local procedure RequestFile();
    begin
        IF FileName <> '' THEN
            ServerFileName := FileMgt.UploadFile(Text001, FileName)
        ELSE
            ServerFileName := FileMgt.UploadFile(Text001, '..xlsx');

        ValidateServerFileName;

        FileName := FileMgt.GetFileName(ServerFileName);
    end;

    local procedure ValidateServerFileName();
    begin
        IF ServerFileName = '' THEN BEGIN
            FileName := '';
            SheetName := '';
            ERROR(Text002);
        END;
    end;

    local procedure ReadExcelSheet(p_FileName: Text[250]; p_SheetName: Text[250]);
    begin
        ExcelBuf.LOCKTABLE;
        ExcelBuf.OpenBook(p_FileName, p_SheetName);
        ExcelBuf.ReadSheet;
    end;

    local procedure GetExcelCell(p_RowNo: Integer; p_ColumnNo: Integer): Text;
    begin
        IF ExcelBuf.GET(p_RowNo, p_ColumnNo) THEN
            EXIT(ExcelBuf."Cell Value as Text");
        EXIT('');
    end;


    local procedure GetExcelCellDecimal(p_RowNo: Integer; p_ColumnNo: Integer): Decimal;
    var
        CellValueAsDecimal: Decimal;
    begin
        IF ExcelBuf.GET(p_RowNo, p_ColumnNo) THEN begin
            Evaluate(CellValueAsDecimal, ExcelBuf."Cell Value as Text");
            EXIT(CellValueAsDecimal);
        end else begin
            EXIT(0);
        end;
    end;

    local procedure fn_TempLevyCompLineNo(): Integer;
    var
        TempLevyCompLineNo: Record "Temp Levy Computations";
    begin
        IF TempLevyCompLineNo.FINDLAST() THEN
            EXIT(TempLevyCompLineNo."Line No." + 1);
        EXIT(1);
    end;
}

