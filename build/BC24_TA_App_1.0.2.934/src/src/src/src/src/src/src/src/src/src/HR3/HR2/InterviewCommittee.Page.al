namespace ABH_UAT.ABH_UAT;

page 51540 "Interview Committee"
{
    ApplicationArea = All;
    Caption = 'Interview Committee';
    PageType = List;
    SourceTable = "Interview Committee";
    UsageCategory = Lists;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(User; Rec.User)
                {
                    ToolTip = 'Specifies the value of the User field.', Comment = '%';
                }
                field("Inteviewer Name";"Inteviewer Name"){}
                
                field(Designation; Rec.Designation)
                {
                    ToolTip = 'Specifies the value of the Designation field.', Comment = '%';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.', Comment = '%';
                }
                field(UserPassword; Rec.UserPassword)
                {
                    ToolTip = 'Specifies the value of the UserPassword field.', Comment = '%';
                }
            }
        }
    }
}
