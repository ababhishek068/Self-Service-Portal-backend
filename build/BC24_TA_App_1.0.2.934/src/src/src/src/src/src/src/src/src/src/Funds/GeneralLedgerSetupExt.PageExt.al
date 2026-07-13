pageextension 50015 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter(SEPAExportWoBankAccData)
        {
            field("Allow G/L Acc. Deletion Before1"; Rec."Allow G/L Acc. Deletion Before")
            {
                ApplicationArea = basic;
                ToolTip = 'Specifies if and when general ledger accounts can be deleted. If you enter a date, G/L accounts with entries on or after this date can be deleted only after confirmation by the user. This setting is only valid when "Block Deletion of G/L accounts" is set to No';
            }
        }
    }


    actions
    {
        addafter("Change Payment &Tolerance")
        {
            action("Clear Database")
            {
                Caption = 'StartUp Database Clearance';
                Image = Delete;
                ApplicationArea = basic;
                ToolTip = 'Executes the StartUp Database Clearance action.';

                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                    BankEntry: Record "Bank Account Ledger Entry";
                    CustL: Record "Cust. Ledger Entry";
                    CustD: Record "Detailed Cust. Ledg. Entry";
                    VendL: Record "Vendor Ledger Entry";
                    VendD: Record "Detailed Vendor Ledg. Entry";
                    ItemL: Record "Item Ledger Entry";
                    ItemV: Record "Value Entry";
                    SalesInvH: Record "Sales Invoice Header";
                    SalesInvL: Record "Sales Invoice Line";
                    PurchInvH: Record "Purch. Inv. Header";
                    PurchInvL: Record "Purch. Inv. Line";
                    PurchRecptH: Record "Purch. Rcpt. Header";
                    PurchRecptL: Record "Purch. Rcpt. Line";
                    UserRec: Record "User Setup";
                    PayHeader: Record "Payments Header";
                    PayLine: Record "Payment Line";
                    ImprestLine: Record "Imprest Lines";
                    ImprestH: Record "Imprest Header";
                    ClaimH: Record "Staff Claims Header";
                    ClaimLine: Record "Staff Claim Lines";
                    BankTransfer: Record "InterBank Transfers";
                    ReceiptH: record "Receipts Header";
                    ReceiptLine: Record "Receipt Line q";
                    StudReceipts: Record Receipt;
                    BudgetName: Record "G/L Budget Name";
                    BudgetEntry: record "G/L Budget Entry";

                begin

                    if UserRec.get(UserId) then
                        if UserRec."Approval Administrator" = false then
                            error('You are not authorized to use this function');
                    if not UserRec.get(UserId) then error('You are not authorized to use this function');

                    if Dialog.StrMenu('Testing,Real,Actual,New Company,Known,MBS,Clear,Aroma,Den,Yes,BT,DS,BK,HR,TR,YU,BV,CX,ZA,KP,MU,KABU,MMU', 3, 'Enter Clearance Key') = 8 then begin
                        if Confirm('Please ensure that you have done system backup before executing this function, Do you want to proceed?', false) then begin
                            if Confirm('Are you sure you want to delete all entries in the system?', false) then begin
                                if Confirm('Please note that this process is irriversable do you still want to proceed?', false) then begin
                                    GLEntry.DeleteAll();
                                    BankEntry.DeleteAll();
                                    CustL.DeleteAll();
                                    VendL.DeleteAll();
                                    CustD.DeleteAll();
                                    VendD.DeleteAll();
                                    ItemL.DeleteAll();
                                    ItemV.DeleteAll();
                                    SalesInvH.DeleteAll();
                                    SalesInvL.DeleteAll();
                                    PurchInvH.DeleteAll();
                                    PurchInvL.DeleteAll();
                                    PurchRecptH.DeleteAll();
                                    PurchRecptL.DeleteAll();
                                    ReceiptH.DeleteAll();
                                    ReceiptLine.DeleteAll();
                                    StudReceipts.DeleteAll();
                                    PayHeader.DeleteAll();
                                    PayLine.DeleteAll();
                                    ClaimH.DeleteAll();
                                    ClaimLine.DeleteAll();
                                    ImprestH.DeleteAll();
                                    ImprestLine.DeleteAll();
                                    BankTransfer.DeleteAll();
                                    BudgetEntry.DeleteAll();
                                    BudgetName.DeleteAll();
                                    Message('Process Completed');
                                end;
                            end;
                        end;

                    end;
                end;

            }
        }
    }


}