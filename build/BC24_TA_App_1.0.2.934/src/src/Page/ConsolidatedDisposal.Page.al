page 50257 "Consolidated Disposal"
{
    Caption = 'Disposal Plan - Consolidated';
    Editable = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions';
    SourceTable = "Cons. Disposal Plan Lines";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                ShowAsTree = false;
                field("Disposal  No"; Rec."Disposal  No")
                {
                    ToolTip = 'Specifies the value of the Disposal  No field.';
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the value of the Line No. field.';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.';
                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Description 2"; Rec."Description 2")
                {
                    ToolTip = 'Specifies the value of the Description 2 field.';
                }
                field("Request Status"; Rec."Request Status")
                {
                    ToolTip = 'Specifies the value of the Request Status field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Reserved Price"; Rec."Reserved Price")
                {
                    ToolTip = 'Specifies the value of the Reserved Price field.';
                }
                field("Price Disposed"; Rec."Price Disposed")
                {
                    ToolTip = 'Specifies the value of the Price Disposed field.';
                }
                field("Total Price"; Rec."Total Price")
                {
                    ToolTip = 'Specifies the value of the Total Price field.';
                }
                field("Justification For Disposal"; Rec."Justification For Disposal")
                {
                    ToolTip = 'Specifies the value of the Justification For Disposal field.';
                }
                field("Item Life Span"; Rec."Item Life Span")
                {
                    ToolTip = 'Specifies the value of the Item Life Span field.';
                }
                field("Tag No."; Rec."Tag No.")
                {
                    ToolTip = 'Specifies the value of the Tag No. field.';
                }
                field("Serial No"; Rec."Serial No")
                {
                    ToolTip = 'Specifies the value of the Serial No field.';
                }
                field("Fixed Location"; Rec."Fixed Location")
                {
                    ToolTip = 'Specifies the value of the Fixed Location field.';
                }
                field(Disposed; Rec.Disposed)
                {
                    ToolTip = 'Specifies the value of the Disposed field.';
                }
                field("Disposal Method"; Rec."Disposal Method")
                {
                    ToolTip = 'Specifies the value of the Disposal Method field.';
                }
                field("Disposal Method 1"; Rec."Disposal Method 1")
                {
                    ToolTip = 'Specifies the value of the Disposal Method 1 field.';
                }
                field("Disposal Method 2"; Rec."Disposal Method 2")
                {
                    ToolTip = 'Specifies the value of the Disposal Method 2 field.';
                }
                field("Reason for Method Change"; Rec."Reason for Method Change")
                {
                    ToolTip = 'Specifies the value of the Reason for Method Change field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook) { }
            systempart(Notes; Notes) { }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Visible = false;
                action(IndentWorkPlan)
                {
                    Caption = 'Indent Workplan Activities';
                    Image = IndentChartOfAccounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit 50010;
                    ToolTip = 'Executes the Indent Workplan Activities action.';
                }
                action("Import Procurement Plan ")
                {
                    Caption = 'Import Procurement Plan';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Executes the Import Procurement Plan action.';

                    trigger OnAction()
                    begin

                    end;
                }
                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Executes the Approvals action.';

                    trigger OnAction()
                    begin

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnOpenPage()
    begin
    end;

    var
        [InDataSet]
        NameIndent: Integer;


}

