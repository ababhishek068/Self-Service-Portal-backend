page 50476 "Research Quiz Header"
{
    PageType = Document;
    ApplicationArea = All;
    UsageCategory = Documents;
    SourceTable = "Research Questionares Header";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No field.';

                }
                field("Research No"; Rec."Research No")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Research No field.';

                }
                field("Stake Holder"; Rec."Stake Holder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Stake Holder field.';

                }
                field("Partner Category"; Rec."Partner Category")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Partner Category field.';

                }
                field("Results Type"; Rec."Results Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Results Type field.';

                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Remarks field.';

                }
            }
            group(Lines)
            {
                part(ResearchLines; "Research Quiz Lines")
                {
                    ApplicationArea = basic;
                }
            }
        }
        area(Factboxes)
        {
            part("Attached Documents"; "Document Attachments")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(58655),
                              "No." = FIELD("No");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadLines)
            {
                ApplicationArea = All;
                Image = Line;
                Caption = 'Refresh Lines';
                ToolTip = 'Executes the Refresh Lines action.';
                trigger OnAction();
                var
                    ReseachQ: Record "Research Questions";
                    RQuizLines: record "Research Quiz Lines";
                    i: Integer;
                begin
                    ReseachQ.reset;
                    ReseachQ.setrange(Category, Rec."Partner Category");
                    if ReseachQ.find('-') then begin
                        repeat
                            RQuizLines.reset;
                            RQuizLines.setrange(No, Rec.No);
                            RQuizLines.setrange(Code, ReseachQ.Code);
                            if not RQuizLines.find('-') then begin
                                i := i + 1;
                                RQuizLines.init;
                                RQuizLines.No := Rec.No;
                                RQuizLines."Line No" := i;
                                RQuizLines.code := ReseachQ.Code;
                                RQuizLines.Description := ReseachQ.Description;
                                RQuizLines."Results Type" := Rec."Results Type";
                                RQuizLines.insert;
                            end;
                        until ReseachQ.next = 0;
                    end;
                    Message('Completed');
                end;
            }
        }
    }
}