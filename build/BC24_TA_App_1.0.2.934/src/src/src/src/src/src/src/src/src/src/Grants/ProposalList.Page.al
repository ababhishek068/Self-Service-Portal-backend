Page 50479 "Proposal List"
{
    Caption = 'Grant List';
    CardPageID = "Proposal Card";
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = Jobs;
    SourceTableView = where(Status = const(Proposal),
                            "Approval Status" = filter(Open | "Pending Approval"));
    ApplicationArea = All;

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
        area(factboxes)
        {
            systempart(Control8; Links)
            {
                Editable = false;
                Visible = true;
            }
            systempart(Control7; Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Grant)
            {
                Caption = '&Grant';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Proposal Card";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'Executes the Card action.';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Job),
                                  "No." = field("No.");
                    ToolTip = 'Executes the Co&mments action.';
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        RunObject = Page "Grant Task Dimensions";
                        RunPageLink = "Job No." = field("No."),
                                      "Job Task No." = const();
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'Executes the Dimensions-Single action.';
                    }
                    action(DimensionsMultiple)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        ToolTip = 'Executes the Dimensions-&Multiple action.';

                        trigger OnAction()
                        var
                            Job: Record Jobs;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Job);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    RunObject = Page "Grant Ledger Entries";
                    RunPageLink = "Job No." = field("No.");
                    RunPageView = sorting("Job No.", "Job Task No.", "Entry Type", "Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'Executes the Ledger E&ntries action.';
                }
                action(GrantTaskLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Grant Task Lines';
                    ToolTip = 'Executes the Grant Task Lines action.';

                    trigger OnAction()
                    var
                        JTLines: Page "Grant Task Lines";
                    begin
                        JTLines.SetJobNo(Rec."No.");
                        JTLines.Run;
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Grant Statistics";
                    RunPageLink = "No." = field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'Executes the Statistics action.';
                }
            }
        }
        area(processing)
        {
            action(Gl)
            {
                ApplicationArea = Basic;
                Caption = 'G/l';
                RunObject = Page "G/L Account Card";
                ToolTip = 'Executes the G/l action.';
            }
        }
        area(reporting) { }
    }
}

