page 50854 "Staff Claim Lines"
{
    PageType = ListPart;
    SourceTable = "Staff Claim Lines";
    UsageCategory = lists;
    ApplicationArea = all;
    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Advance Type"; Rec."Advance Type")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Claim Type field.';
                    trigger OnValidate()
                    begin
                        RecPay.Reset;
                        RecPay.SetRange(RecPay.Code, Rec."Advance Type");
                        if RecPay.Find('-') then begin
                            Rec."Account No:" := RecPay."G/L Account";
                            //"Lecturer NoVisible" := TRUE;
                        end;
                    end;
                }
                field(No; Rec.No)
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field("Account No:"; Rec."Account No:")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Account No: field.';


                }
                field("Account Name"; Rec."Account Name")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Account Name field.';
                }



                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Amount field.';

                    trigger OnValidate()
                    begin
                        /*{Get the total amount paid}
                        Bal:=0;
                        
                        PayHeader.RESET;
                        PayHeader.SETRANGE(PayHeader."Line No.",No);
                        IF PayHeader.FINDFIRST THEN
                          BEGIN
                            PayLine.RESET;
                            PayLine.SETRANGE(PayLine.No,PayHeader."Line No.");
                            IF PayLine.FIND('-') THEN
                              BEGIN
                                REPEAT
                                  Bal:=Bal + PayLine."Pay Mode";
                                UNTIL PayLine.NEXT=0;
                              END;
                          END;
                        //Bal:=Bal + Amount;
                        
                        IF Bal > PayHeader.Amount THEN
                          BEGIN
                            ERROR('Please ensure that the amount inserted does not exceed the amount in the header');
                          END;
                          */

                    end;
                }
                field(Patient;Patient){
                    trigger OnValidate()
                    begin
                        if ("Advance Type"<>'MEDICAL') then begin
                            Error('You must select only if claim type is medical');
                        end;
                    end;
                }
                field("Medical Amount"; Rec."Medical Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Medical Amount field.';
                }
                field("Amount to refund";"Amount to refund"){
                    Caption='Meical amount to refund';
                }
                field("Claim Receipt No"; Rec."Claim Receipt No")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Claim Receipt No field.';
                }
                field("Expenditure Date"; Rec."Expenditure Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expenditure Date field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    Caption = 'Expenditure Description';
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Expenditure Description field.';
                }
                field("Budgeted Amount"; Rec."Budgeted Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Budgeted Amount field.';
                }
                field("Actual Expenditure"; Rec."Actual Expenditure")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Actual Expenditure field.';
                }
                field("Committed Amount"; Rec."Committed Amount")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the Committed Amount field.';
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    var
        BudgControl: Record "Budgetary Control Setup";
    begin
        BudgControl.get;
        Rec.SetFilter("Date Filter", '%1..%2', BudgControl."Current Budget Start Date", BudgControl."Current Budget End Date");
        Rec.CalcFields("Committed Amount");
        //CalcFields("Actual Expenditure");
        Rec.CalcFields("Budgeted Amount");
    end;


    var
        RecPay: Record "Receipts and Payment Types";
}

