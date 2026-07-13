Page 50975 "Marketting List"
{
    CardPageID = "Marketting Card";
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = where(Status = const(Market),
                            "Approval Status" = filter(Open | "Pending Approval"));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. field.';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Stakeholder; Rec.Stakeholder)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Stakeholder field.';
                }

                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Creation Date field.';
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(PersonResponsible; Rec."Person Responsible")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Person Responsible field.';
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
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Kind of Program field.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Blocked field.';
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Last Date Modified field.';
                }
                field(Comment; Rec.Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Comment field.';
                }

                field(LanguageCode; Rec."Language Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Language Code field.';
                }
                field(ScheduledResQty; Rec."Scheduled Res. Qty.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Scheduled Res. Qty. field.';
                }

            }
        }
    }

    actions { }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Status := Rec.Status::QA;
    end;
}

