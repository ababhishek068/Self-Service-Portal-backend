Page 51192 "Employee Qualifications 2"
{
    PageType = ListPart;
    SourceTable = "Employee Qualifications Fin";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EmployeeNo; Rec."Employee No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee No. field.';
                }
                field(Qualification; Rec.Qualification)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Qualification field.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Type field.';
                }
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
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Institution; Rec.Institution)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Institution field.';
                }
                field(InstitutionName; Rec."Institution Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Institution Name field.';
                }
                field(HighestQualification; Rec."Highest Qualification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Highest Qualification field.';
                }
                field(Rank; Rec.GPA)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the GPA field.';
                }
            }
        }
    }

    actions { }
}

