Page 50398 "prPCA list"
{
    CardPageID = prPayChangeAdvice;
    PageType = List;
    SourceTable = "prBasic pay PCA";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeCode; Rec."Employee Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Code field.';
                }
                field(EmployeeName; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field(BasicPay; Rec."Basic Pay")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Basic Pay field.';
                }
                field(Comments; Rec.Comments)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comments field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PayrollPeriod; Rec."Payroll Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payroll Period field.';
                }
                field(ChangeAdviceSerialNo; Rec."Change Advice Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Change Advice Serial No. field.';
                }
                field(Effected; Rec.Effected)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Effected field.';
                }
                field(PAyrollCode; Rec.PAyrollCode)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PAyrollCode field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control3; Notes) { }
            systempart(Control2; MyNotes) { }
            systempart(Control1; Links) { }
        }
    }

    actions { }
}

