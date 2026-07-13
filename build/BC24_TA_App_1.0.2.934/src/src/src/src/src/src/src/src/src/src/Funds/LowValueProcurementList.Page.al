Page 50719 "Low Value Procurement List"
{
    CardPageID = "Low Value Procurement";
    PageType = List;
    SourceTable = "Purchase Quote Header";
    SourceTableView = where("Document Type" = const("Low Value Procurement"),
                            Status = filter(<> Released));
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
                field(ExpectedOpeningDate; Rec."Expected Opening Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Opening Date field.';
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field(ExpectedClosingDate; Rec."Expected Closing Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expected Closing Date field.';
                }
                field(PostingDescription; Rec."Posting Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posting Description field.';
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
            }
        }
    }

    actions { }
}

