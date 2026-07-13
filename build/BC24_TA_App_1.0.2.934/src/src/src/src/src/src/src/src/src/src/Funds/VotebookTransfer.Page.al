Page 50519 "Votebook Transfer"
{
    PageType = Card;
    SourceTable = "Vote Transfer";
    PromotedActionCategories = 'New,Process,Report,Approval';
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
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
                field(SourceVote; Rec."Source Vote")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Vote field.';
                }
                field(DestinationVote; Rec."Destination Vote")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Vote field.';
                }
                field(BudgetName; Rec."Budget Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Budget Name field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field(SourceDimmension1; Rec."Source Dimmension 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Dimmension 1 field.';
                }
                field(DestinationDimmension1; Rec."Destination Dimmension 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Dimmension 1 field.';
                }
                field(SourceDimmension2; Rec."Source Dimmension 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Source Dimmension 2 field.';
                }
                field(DestinationDimmension2; Rec."Destination Dimmension 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Destination Dimmension 2 field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
                field(RaisedBy; Rec."Raised By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Raised By field.';
                }
                field(RaisedDate; Rec."Raised Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Raised Date field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Posted field.';
                }

            }
        }
        area(factboxes)
        {
            part(Control25; "Budget Matrix") { }
            systempart(Control26; Notes) { }
            systempart(Control27; Links) { }
            systempart(Control28; MyNotes) { }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup17)
            {
                action(sendApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Send A&pproval Request action.';

                    trigger OnAction()
                    begin

                        Rec.TestField(Posted, false);

                        varVariant := Rec;
                        if CustomApprovals.CheckApprovalsWorkflowEnabled(VarVariant) then
                            CustomApprovals.OnSendDocForApproval(VarVariant);

                    end;
                }
                action(cancellsApproval)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Re&quest';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Cancel Approval Re&quest action.';

                    trigger OnAction()
                    var
                        VarVariant: Variant;
                    begin

                        VarVariant := Rec;
                        CustomApprovals.OnCancelDocApprovalRequest(VarVariant);


                    end;
                }
            }
            separator(Action33) { }
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Post action.';

                trigger OnAction()
                begin
                    //post the document
                    PostDoc;
                end;
            }
            action(PostPrint)
            {
                ApplicationArea = Basic;
                Caption = 'Post & Print';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Executes the Post & Print action.';

                trigger OnAction()
                begin
                    //post and print the document
                    PostDoc;

                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    Report.Run(70135528, true, true, Rec);
                    Rec.Reset;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic;
                Caption = 'Print';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Executes the Print action.';

                trigger OnAction()
                begin
                    //print
                    Rec.TestField(Status, Rec.Status::Approved);
                    Rec.Reset;
                    Rec.SetFilter(No, Rec.No);
                    Report.Run(70135528, true, true, Rec);
                    Rec.Reset;
                end;
            }
        }
    }

    var
        VarVariant: Variant;
        CustomApprovals: Codeunit "Custom Approvals Codeunit";

    procedure TestFields()
    var
        GlAcc: Record "G/L Account";
    begin
        Rec.TestField(Remarks);
        Rec.TestField(Date);
        Rec.TestField("Budget Name");
        Rec.TestField("Source Dimmension 1");
        Rec.TestField("Destination Dimmension 1");
        Rec.TestField("Source Dimmension 2");
        Rec.TestField("Destination Dimmension 2");
        //TESTFIELD("Responsibility Center");

        GlAcc.SetRange("No.", Rec."Source Vote");
        //GlAcc.SETRANGE("Dimension Set ID Filter","Dimension Set ID");
        GlAcc.SetRange("Budget Filter", Rec."Budget Name");
        GlAcc.FindSet;
        GlAcc.CalcFields("Budgeted Amount", "Net Change");
        //IF (GLAcc."Budgeted Amount" - glacc."net change" - Amount) <= 0 THEN ERROR('The amount will result in a negative budget balance');
        if (GlAcc."Budgeted Amount") <= 0 then Error('The amount will result in a negative budget balance');
        if (GlAcc."Budgeted Amount" - Rec.Amount) <= 0 then Error('The amount will result in a negative budget balance');
    end;

    procedure PostDoc()
    var
        BudgetEntry: Record "G/L Budget Entry";
    begin
        TestFields;
        Rec.TestField(Status, Rec.Status::Approved);
        Rec.TestField(Posted, false);
        if not Confirm('Are you sure you want to post the document', false) then exit;

        BudgetEntry.Init;
        BudgetEntry."Entry No." := 0;
        BudgetEntry."Budget Name" := Rec."Budget Name";
        BudgetEntry."G/L Account No." := Rec."Source Vote";
        BudgetEntry.Date := Rec.Date;
        BudgetEntry."Global Dimension 1 Code" := Rec."Source Dimmension 1";
        BudgetEntry."Global Dimension 2 Code" := Rec."Source Dimmension 2";
        BudgetEntry.Amount := -Rec.Amount;
        BudgetEntry.Description := StrSubstNo(Rec.No + ' ' + Rec.Remarks, 1, 50);
        BudgetEntry."User ID" := UserId;
        //BudgetEntry."Budget Dimension 1 Code" := "Source Dimmension 3";
        //BudgetEntry."Budget Dimension 2 Code" := "Source Dimmension 4";
        //BudgetEntry."Dimension Set ID" := "Dimension Set ID";
        BudgetEntry.Insert(true);

        BudgetEntry.Init;
        BudgetEntry."Entry No." := 0;
        BudgetEntry."Budget Name" := Rec."Budget Name";
        BudgetEntry."G/L Account No." := Rec."Destination Vote";
        BudgetEntry.Date := Rec.Date;
        BudgetEntry."Global Dimension 1 Code" := Rec."Destination Dimmension 1";
        BudgetEntry."Global Dimension 2 Code" := Rec."Destination Dimmension 2";
        BudgetEntry.Amount := Rec.Amount;
        BudgetEntry.Description := StrSubstNo(Rec.No + ' ' + Rec.Remarks, 1, 50);
        BudgetEntry."User ID" := UserId;
        //BudgetEntry."Budget Dimension 1 Code" := "Destination Dimmension 3";
        //BudgetEntry."Budget Dimension 2 Code" := "Destination Dimmension 4";
        //BudgetEntry."Dimension Set ID" := "Dimension Set ID 2";
        BudgetEntry.Insert(true);

        Rec.Status := Rec.Status::Posted;
        Rec.Posted := true;
        Rec."Posted Date" := Today;
        Rec."Posted By" := UserId;
        Rec.Modify;

        Message('Document sucessfully posted !');
    end;
}

