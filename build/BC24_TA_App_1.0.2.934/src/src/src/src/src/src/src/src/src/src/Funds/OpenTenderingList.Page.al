Page 50842 "Open Tendering List"
{
    CardPageID = "Open Tendering";
    PageType = List;
    SourceTable = "Purchase Quote Header";
    SourceTableView = where("Document Type" = const("Open Tender"),
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
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
            }
        }
    }

    actions { }
}

