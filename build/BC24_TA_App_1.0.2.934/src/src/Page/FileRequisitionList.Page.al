Page 50785 "File Requisition List"
{
    CardPageID = "File Requisition";
    PageType = List;
    SourceTable = "File Requisition";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater("Group")
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(RequestingOfficer; Rec."Requesting Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Requesting Officer field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Designation; Rec.Designation)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Designation field.';
                }
                field(CollectingOfficer; Rec."Collecting Officer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Collecting Officer field.';
                }
                field(Purpose; Rec.Purpose)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Purpose field.';
                }
                field(FileNo; Rec."File No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File No field.';
                }
                field(FileName; Rec."File Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field(AuthorizedBy; Rec."Authorized By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Authorized By field.';
                }
                field(ServedBy; Rec."Served By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Served By field.';
                }
            }
        }
    }

    actions { }
}

