Page 50546 "Audit Annual WorkPlan"
{
    PageType = List;
    SourceTable = "Audit Programmes";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(DateCreated; Rec."Date Created")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Created field.';
                }
                field(DescriptionComment; Rec."Description/Comment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description/Comment field.';
                }
                field(CreatedBy; Rec."Created By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Created By field.';
                }
                field(LastEditedBy; Rec."Last Edited By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Edited By field.';
                }
                field(DateEdited; Rec."Date Edited")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Edited field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(ApprovalComments; Rec."Approval Comments")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approval Comments field.';
                }
                field(NotificationSent; Rec."Notification Sent?")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notification Sent? field.';
                }
            }
        }
    }

    actions { }
}

