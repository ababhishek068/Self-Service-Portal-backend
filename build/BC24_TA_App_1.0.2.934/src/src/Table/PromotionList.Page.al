page 51467 "Promotion List"
{
    ApplicationArea = All;
    Caption = 'Promotion List';
    CardPageId="Promotion Card";
    PageType = List;
    SourceTable = HR_Promotion;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Promtion_No; Rec.Promtion_No)
                {
                    ToolTip = 'Specifies the value of the Promtion_No field.', Comment = '%';
                }
                field(Employee_No; Rec.Employee_No)
                {
                    ToolTip = 'Specifies the value of the Employee_No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Global Dimension 3 Code";"Global Dimension 3 Code"){}
                field("Is HOD"; Rec."Is HOD")
                {
                    ToolTip = 'Specifies the value of the Is HOD field.', Comment = '%';
                }
                field("Job Id"; Rec."Job Id")
                {
                    ToolTip = 'Specifies the value of the Job Id field.', Comment = '%';
                }
                
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.', Comment = '%';
                }
                field(Sector; Rec.Sector)
                {
                    ToolTip = 'Specifies the value of the Sector field.', Comment = '%';
                }
                field(Status; Status) { }
                field(type;type){}
                field("New Position Start Date";"New Position Start Date"){}
                field("Date Created"; "Date Created") { }
            }
        }
    }
}
