Page 51181 "Applicant Employment Details"
{
    PageType = Listpart;
    SourceTable = "Current Employment Details";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(FromDate; Rec."From Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field(ToDate; Rec."To Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field(JobTitle; Rec."Job Title")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Title field.';
                }
                field(Department; Rec.Department)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Department field.';
                }
                field(DutiesandResponsibility; Rec."Duties and Responsibility")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Duties and Responsibility field.';
                }
                field(CurrentBasicSalary; Rec."Current Salary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Current Basic Salary';
                    ToolTip = 'Specifies the value of the Current Basic Salary field.';
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field(MajorAchiements; Rec."Major Achiements")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Major Achiements field.';
                }
                field(ContractType; Rec."Contract Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contract Type field.';
                }
                field(Displinary; Rec.Displinary)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Displinary field.';
                }

                field(EmailAddress; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
                field(LineNo; Rec."Line No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Line No field.';
                }
                field(NoticePeriod; Rec."Notice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notice Period field.';
                }
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field(CurrSupervisor; Rec."Curr Supervisor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Curr Supervisor field.';
                }
                field("Account No"; Rec."Account No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Account No field.';
                }

            }
        }
    }

    actions { }
}

