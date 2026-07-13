Page 50450 "Project List lookup"
{
    Caption = 'Project Summary List';
    CardPageID = "Project Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Jobs";
    ApplicationArea = All;
    // SourceTableView = where(Status = const(Project));

    layout
    {
        area(content)
        {
            repeater(Control1)
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
                field(PersonResponsible; Rec."Person Responsible")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Person Responsible field.';
                }
                field(NextInvoiceDate; Rec."Next Invoice Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Next Invoice Date field.';
                }
                field(JobPostingGroup; Rec."Job Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Kind of Program field.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Search Description field.';
                }
            }
        }
    }

    actions { }
}

