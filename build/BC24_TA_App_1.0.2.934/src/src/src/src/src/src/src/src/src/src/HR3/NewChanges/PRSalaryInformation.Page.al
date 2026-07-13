Page 51288 "PR Salary Information"
{
    AutoSplitKey = false;
    Caption = 'Payment Information';
    UsageCategory = Lists;
    ApplicationArea = All;
    DelayedInsert = true;
    LinksAllowed = false;
    InsertAllowed = true;
    Editable = true;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Reports,Approval,Budgetary Control,Cancellation,Category7_caption,Category8_caption,Category9_caption,Category10_caption';
    SourceTable = "PR Salary Card";

    layout
    {
        area(content)
        {
            repeater(PaymentInfo)
            {
                Caption = 'Payment Info';
                field("Process Advance";"Process Advance"){}
                field(BasicPay; Rec."Basic Pay")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                    Editable = true;
                    trigger OnValidate()
                    begin
                        //Record change being made on which payroll period
                        PRPayrollPeriod.Reset;
                        PRPayrollPeriod.SetRange(PRPayrollPeriod.Closed, false);
                        if not PRPayrollPeriod.FindFirst() then Error('No Open Payroll Period found');

                        //HR Value Change
                        Clear(prEmployees);
                        if prEmployees.Get(Rec."Employee Code") then begin

                        end;
                    end;
                }
                field(PaysPension; Rec."Pays Pension")
                {
                    Visible = true;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pays Pension field.';
                }
                field(PaysNHIF; Rec."Pays NHIF")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pays NHIF field.';
                    Visible = false;
                }
                field(PaysPAYE; Rec."Pays PAYE")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pays Income Tax';
                    ToolTip = 'Specifies the value of the Pays PAYE field.';
                    Editable = true;
                }
                field(DeActivatePersonalRelief; Rec."De-Activate Personal Relief?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the De-Activate Personal Relief? field.';
                }
                field(InsuranceCertificate; Rec."Insurance Certificate?")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Insurance Certificate? field.';
                }


                field("PWD Certificate?"; Rec."PWD Certificate?")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies the value of the PWD Certificate? field.';
                }
                field(SuspendPay; Rec."Suspend Pay")
                {
                    Editable = true;
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Suspend Pay field.';
                }
                field(SuspensionDate; Rec."Suspension Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Suspension Date field.';
                }
                field(SuspensionReasons; Rec."Suspension Reasons")
                {
                    ApplicationArea = Basic;
                    MultiLine = false;
                    Editable = true;
                    ToolTip = 'Specifies the value of the Suspension Reasons field.';
                }

                field("Period Filter";"Period Filter"){}
            }
        }
    }

    actions { }

    trigger OnAfterGetRecord()
    begin
        //CALCFIELDS("Is Paid Daily?");
        ////IF "Is Paid Daily?" = FALSE THEN BPAY_Editable:=TRUE;
    end;

    trigger OnOpenPage()
    begin
        ///BPAY_Editable:=FALSE;
    end;

    var
        PRPayrollPeriod: Record "PR Payroll Periods";
        prEmployees: Record "HR-Employee";
}

