Page 50274 "prEmployee Trans PCA1"
{
    PageType = ListPart;
    SourceTable = "prEmployee Trans PCA";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransactionCode; Rec."Transaction Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Code field.';

                    trigger OnValidate()
                    begin
                        objPCAheader.Reset;
                        objPCAheader.SetRange(objPCAheader."Change Advice Serial No.", Rec."Change Advice Serial No.");
                        if objPCAheader.Find('-') then begin
                            SelectedPeriod := objPCAheader."Payroll Period";
                            Rec."Period Month" := objPCAheader."Period Month";
                            Rec."Period Year" := objPCAheader."Period Year";
                        end;

                        blnIsLoan := false;
                        if objTransCodes.Get(Rec."Transaction Code") then
                            Rec."Transaction Name" := objTransCodes."Transaction Name";
                        Rec."Payroll Period" := SelectedPeriod;
                        // if objTransCodes."Special Transactions"=8 then blnIsLoan:=true;

                        if objTransCodes."Is Formula" = true then begin
                            empCode := Rec."Employee Code";
                            Clear(objOcx);
                            // curTransAmount:=objOcx.fnDisplayFrmlValues(empCode,PeriodMonth,PeriodYear,objTransCodes.Formula);
                            // Amount:=curTransAmount;
                        end;

                        //*************ENTER IF EMPLOYER DEDUCTION IS SET UP
                        curTransAmount := 0;

                        if objTransCodes."Include Employer Deduction" = true then begin
                            // curTransAmount:=objOcx.fnDisplayFrmlValues(empCode,PeriodMonth,PeriodYear,objTransCodes."Is Formula for employer");
                            // "Employer Amount":=curTransAmount;
                        end;
                    end;
                }
                field(TransactionName; Rec."Transaction Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Transaction Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(Balance; Rec.Balance)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Balance field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(EmployerAmount; Rec."Employer Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employer Amount field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(ShortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 3 Code field.';
                }
                field(ShortcutDimension4Code; Rec."Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 4 Code field.';
                }
                field(StartDate; Rec."Start Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Start Date field.';
                }
                field(EndDate; Rec."End Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the End Date field.';
                }
            }
        }
    }

    actions { }

    var
        objTransCodes: Record "pr Transaction Codes";
        SelectedPeriod: Date;
        blnIsLoan: Boolean;
        objOcx: Codeunit "PR Payroll Processing";
        curTransAmount: Decimal;
        empCode: Text[30];
        objPCAheader: Record "prBasic pay PCA";
}

