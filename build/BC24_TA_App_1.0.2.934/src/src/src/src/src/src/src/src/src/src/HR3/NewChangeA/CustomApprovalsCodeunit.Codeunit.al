Codeunit 50030 "Custom Approvals Codeunit"
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        UnsupportedRecordTypeErr: label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
        NoWorkflowEnabledErr: label 'This record is not supported by related approval workflow.';
        OnSendPaymentApprovalRequestTxt: label 'Approval of a Payment is requested';
        RunWorkflowOnSendPaymentForApprovalCode: label 'RUNWORKFLOWONSENDPAYMENTFORAPPROVAL';
        OnCancelPaymentApprovalRequestTxt: label 'An Approval of a Payment is canceled';
        RunWorkflowOnCancelPaymentForApprovalCode: label 'RUNWORKFLOWONCANCELPAYMENTFORAPPROVAL';
        OnSendInterbankApprovalRequestTxt: label 'Approval of a Interbank is requested';
        RunWorkflowOnSendInterbankForApprovalCode: label 'RUNWORKFLOWONSENDINTERBANKFORAPPROVAL';
        OnCancelInterbankApprovalRequestTxt: label 'An Approval of a Interbank is canceled';
        RunWorkflowOnCancelInterbankForApprovalCode: label 'RUNWORKFLOWONCANCELINTERBANKFORAPPROVAL';
        OnSendStaffClaimApprovalRequestTxt: label 'Approval of a Staff Claim is requested';
        RunWorkflowOnSendStaffClaimForApprovalCode: label 'RUNWORKFLOWONSENDSTAFFCLAIMFORAPPROVAL';
        OnCancelStaffClaimApprovalRequestTxt: label 'An Approval of a Staff Claim is canceled';
        RunWorkflowOnCancelStaffClaimForApprovalCode: label 'RUNWORKFLOWONCANCELSTAFFCLAIMFORAPPROVAL';
        OnSendStaffAdvanceApprovalRequestTxt: label 'Approval of a Staff Advance is requested';
        RunWorkflowOnSendStaffAdvanceForApprovalCode: label 'RUNWORKFLOWONSENDSTAFFADVANCEFORAPPROVAL';
        OnCancelStaffAdvanceApprovalRequestTxt: label 'An Approval of a Staff Advance is canceled';
        RunWorkflowOnCancelStaffAdvanceForApprovalCode: label 'RUNWORKFLOWONCANCELSTAFFADVANCEFORAPPROVAL';
        OnSendStaffAdvanceSurrenderApprovalRequestTxt: label 'Approval of a Staff Advance Surrender is requested';
        RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode: label 'RUNWORKFLOWONSENDSTAFFADVANCESURRENDERFORAPPROVAL';
        OnCancelStaffAdvanceSurrenderApprovalRequestTxt: label 'An Approval of a Staff Advance Surrender is canceled';
        RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode: label 'RUNWORKFLOWONCANCELSTAFFADVANCESURRENDERFORAPPROVAL';
        OnSendStoreRequisitionApprovalRequestTxt: label 'Approval of a Store Requisition is requested';
        RunWorkflowOnSendStoreRequisitionForApprovalCode: label 'RUNWORKFLOWONSENDSTOREREQUISITIONFORAPPROVAL';
        OnCancelStoreRequisitionApprovalRequestTxt: label 'An Approval of a Store Requisition is canceled';
        RunWorkflowOnCancelStoreRequisitionForApprovalCode: label 'RUNWORKFLOWONCANCELSTOREREQUISITIONFORAPPROVAL';
        OnSendImprestApprovalRequestTxt: label 'Approval of a Imprest is requested';
        RunWorkflowOnSendImprestForApprovalCode: label 'RUNWORKFLOWONSENDIMPRESTFORAPPROVAL';
        OnCancelImprestApprovalRequestTxt: label 'An Approval of a Imprest is canceled';
        RunWorkflowOnCancelImprestForApprovalCode: label 'RUNWORKFLOWONCANCELIMPRESTFORAPPROVAL';
        OnSendImprestSurrenderApprovalRequestTxt: label 'Approval of a Imprest Surrender is requested';
        RunWorkflowOnSendImprestSurrenderForApprovalCode: label 'RUNWORKFLOWONSENDIMPRESTSURRENDERFORAPPROVAL';
        OnCancelImprestSurrenderApprovalRequestTxt: label 'An Approval of a Imprest Surrender is canceled';
        RunWorkflowOnCancelImprestSurrenderForApprovalCode: label 'RUNWORKFLOWONCANCELIMPRESTSURRENDERFORAPPROVAL';
        OnSendBudgetApprovalRequestTxt: label 'Approval of a Budget is requested';
        RunWorkflowOnSendBudgetForApprovalCode: label 'RUNWORKFLOWONSENDBUDGETFORAPPROVAL';
        OnCancelBudgetApprovalRequestTxt: label 'An Approval of a Budget is canceled';
        RunWorkflowOnCancelBudgetForApprovalCode: label 'RUNWORKFLOWONCANCELBUDGETFORAPPROVAL';
        OnSendVoteApprovalRequestTxt: label 'Approval of a Vote Transfer is requested';
        RunWorkflowOnSendVoteForApprovalCode: label 'RUNWORKFLOWONSENDVOTEFORAPPROVAL';
        OnCancelVoteApprovalRequestTxt: label 'An Approval of a Vote is canceled';
        RunWorkflowOnCancelVoteForApprovalCode: label 'RUNWORKFLOWONCANCELVOTEFORAPPROVAL';
        OnSendWorkplanApprovalRequestTxt: label 'Approval of a Workplan is requested';
        RunWorkflowOnSendWorkplanForApprovalCode: label 'RUNWORKFLOWONSENDWORKPLANFORAPPROVAL';
        OnCancelWorkplanApprovalRequestTxt: label 'An Approval of a Workplan is canceled';
        RunWorkflowOnCancelWorkplanForApprovalCode: label 'RUNWORKFLOWONCANCELWORKPLANFORAPPROVAL';

        OnSendWorkplanActivitiesApprovalRequestTxt: label 'Approval of Workplan Activities is requested';
        RunWorkflowOnSendWorkplanActivitiesForApprovalCode: label 'RUNWORKFLOWONSENDWORKPLANACTIVITIESFORAPPROVAL';
        OnCancelWorkplanActivitiesApprovalRequestTxt: label 'An Approval of a Workplan Activities is canceled';
        RunWorkflowOnCancelWorkplanActivitiesForApprovalCode: label 'RUNWORKFLOWONCANCELWORKPLANACTIVITIESFORAPPROVAL';
        // "**Dynsoft Hr**": ;
        OnSendHrJobsApprovalRequestTxt: label 'An Approval Request for a Job Position has been requested.';
        RunWorkflowOnSendHrJobsForApprovalCode: label 'RUNWORKFLOWONSENDHRJOBSFORAPPROVAL';
        OnCancelHrJobsApprovalRequestTxt: label 'An Approval Request for a Job Position has been cancelled.';
        RunWorkflowOnCancelHrJobsForApprovalCode: label 'RUNWORKFLOWONCANCELHRJOBSFORAPPROVAL';
        RunWorkflowOnSendHrEmployeeReqForApprovalCode: label 'RUNWORKFLOWONSENDHREMPLOYEEREQFORAPPROVAL';
        RunWorkflowOnCancelHrEmployeeReqForApprovalCode: label 'RUNWORKFLOWONCANCELHREMPLOYEEREQFORAPPROVAL';
        OnSendHrLeaveApprovalRequestTxt: label 'An Approval Request for Leave application has been Requested.';
        RunWorkflowOnSendHrLeaveForApprovalCode: label 'RUNWORKFLOWONSENDHRLEAVEFORAPPROVAL';
        OnCancelHrLeaveApprovalRequestTxt: label 'An Approval Request for Leave Application has been Cancelled';
        RunWorkflowOnCancelHrLeaveForApprovalCode: label 'RUNWORKFLOWONCANCELHRLEAVEFORAPPROVAL';
        OnSendHrTrainingApprovalRequestTxt: label 'An Approval Request for Training application has been Requested.';
        RunWorkflowOnSendHrTrainingForApprovalCode: label 'RUNWORKFLOWONSENDHRTRAININGFORAPPROVAL';
        OnCancelHrTrainingApprovalRequestTxt: label 'An Approval Request for Training Application has been Cancelled';
        RunWorkflowOnCancelHrTrainingForApprovalCode: label 'RUNWORKFLOWONCANCELHRTRAININGFORAPPROVAL';
        // "***Investment*****": ;
        OnSendInvestimentApprovalRequestTxt: label 'An Approval Request for Investiment application has been Requested.';
        RunWorkflowOnSendInvestimentForApprovalCode: label 'RUNWORKFLOWONSENDINVESTIMENTFORAPPROVAL';
        OnCancelInvestimentApprovalRequestTxt: label 'An Approval Request for Investiment Application has been Cancelled';
        RunWorkflowOnCancelInvestimentForApprovalCode: label 'RUNWORKFLOWONCANCELINVESTIMENTFORAPPROVAL';
        //"*****End Academics*******": ;
        //Fleet
        OnSendTransportApprovalRequestTxt: label 'An Approval Request for Transport has been Requested.';
        RunWorkflowOnSendTransportForApprovalCode: label 'RUNWORKFLOWONSENDTRANSPORTFORAPPROVAL';
        RunWorkflowOnCancelTransportApprovalCode: label 'RUNWORKFLOWONCANCELTRANSPORTFORAPPROVAL';
        OnCancelTransportApprovalRequestTxt: label 'An Approval Request for Transport has been Cancelled';
        //Grants
        OnSendProposalApprovalRequestTxt: label 'An Approval Request for Proposal has been Requested.';
        RunWorkflowOnSendProposalForApprovalCode: label 'RUNWORKFLOWONSENDPROPOSALFORAPPROVAL';
        RunWorkflowOnCancelProposalApprovalCode: label 'RUNWORKFLOWONCANCELPROPOSALFORAPPROVAL';
        OnCancelProposalApprovalRequestTxt: label 'An Approval Request for Proposal has been Cancelled';

        OnSendConferenceApprovalRequestTxt: label 'An Approval Request for Conference has been Requested.';
        RunWorkflowOnSendConferenceForApprovalCode: label 'RUNWORKFLOWONSENDPROPOSALFORAPPROVAL';
        RunWorkflowOnCancelConferenceApprovalCode: label 'RUNWORKFLOWONCANCELCONFERENCEFORAPPROVAL';
        OnCancelConferenceApprovalRequestTxt: label 'An Approval Request for Conference has been Cancelled';

        //Purchase Requisition
        OnSendPurchaseRequisitionApprovalRequestTxt: label 'An Approval Request for Purchase Requisition has been Requested.';
        RunWorkflowOnSendPurchaseRequisitionForApprovalCode: label 'RUNWORKFLOWONSENDPURCHASEREQUISITIONFORAPPROVAL';
        RunWorkflowOnCancelPurchaseRequisitionApprovalCode: label 'RUNWORKFLOWONCANCELPURCHASEREQUIAITIONFORAPPROVAL';
        OnCancelPurchaseRequisitionApprovalRequestTxt: label 'An Approval Request for Purchase Requisition has been Cancelled';

        //Vendor Buffer
        OnSendVendorBufferApprovalRequestTxt: label 'An Approval Request for Vendor Prequalification has been Requested.';
        RunWorkflowOnSendVendorBufferForApprovalCode: label 'RUNWORKFLOWONSENDVENDORBUFFERFORAPPROVAL';
        RunWorkflowOnCancelVendorBufferApprovalCode: label 'RUNWORKFLOWONCANCELVENDORBUFFERFORAPPROVAL';
        OnCancelVendorBufferApprovalRequestTxt: label 'An Approval Request for Vendor Prequalification has been Cancelled';
        //Transfer Order
        OnSendTransferOrderApprovalRequestTxt: label 'An Approval Request for Transfer Order has been Requested.';
        RunWorkflowOnSendTransferOrderForApprovalCode: label 'RUNWORKFLOWONSENDTRANSFERORDERFORAPPROVAL';
        RunWorkflowOnCancelTransferOrderApprovalCode: label 'RUNWORKFLOWONCANCELTRANSFERORDERFORAPPROVAL';
        OnCancelTransferOrderApprovalRequestTxt: label 'An Approval Request for Transfer Order has been Cancelled';
        //Training Evaluation
        OnSend_TrainingEvaluation_ApprovalRequestTxt: label 'An Approval Request for Training Evaluation has been Requested.';
        RunWorkflowOnSend_TrainingEvaluation_ForApprovalCode: label 'RUNWORKFLOWONSEND_TrainingEvaluation_FORAPPROVAL';
        RunWorkflowOnCancel_TrainingEvaluation_ApprovalCode: label 'RUNWORKFLOWONCANCEL_TrainingEvaluation_FORAPPROVAL';
        OnCancel_TrainingEvaluation_ApprovalRequestTxt: label 'An Approval Request for Training Evaluation has been Cancelled';
        //RFQ  Purchase Quote
        OnSendRFQApprovalRequestTxt: label 'An Approval Request for Request for Quote has been Requested.';
        RunWorkflowOnSendRFQForApprovalCode: label 'RUNWORKFLOWONSENDRFQFORAPPROVAL';
        RunWorkflowOnCancelRFQApprovalCode: label 'RUNWORKFLOWONCANCELRFQFORAPPROVAL';
        OnCancelRFQApprovalRequestTxt: label 'An Approval Request for Request for Quote has been Cancelled';
        // Bank Reconcilliation
        OnSendBanksReconApprovalRequestTxt: Label 'Approval of a BankRecon is requested';
        RunWorkflowOnSendBanksReconForApprovalCode: Label 'RUNWORKFLOWONSENDBankReconFORAPPROVAL';
        OnCancelBanksReconApprovalRequestTxt: Label 'An Approval of a BankRecon is canceled';
        RunWorkflowOnCancelBanksReconForApprovalCode: Label 'RUNWORKFLOWONCANCELBankReconFORAPPROVAL';

        //Imprest memo
        OnSendImpMemoApprovalRequestTxt: label 'An Approval Request for Imprest Memo has been Requested.';
        RunWorkflowOnSendImpMemoForApprovalCode: label 'RUNWORKFLOWONSENDIMPMEMOFORAPPROVAL';
        RunWorkflowOnCancelImpMemoApprovalCode: label 'RUNWORKFLOWONCANCELIMPMEMOFORAPPROVAL';
        OnCancelImpMemoApprovalRequestTxt: label 'An Approval Request for Imprest Memo has been Cancelled';


        //Direct Voucher GreenCom
        OnSendDirectVoucherGreenComApprovalRequestTxt: label 'An Approval Request for Direct Voucher GreenCom has been Requested.';
        RunWorkflowOnSendDirectVoucherGreenComForApprovalCode: label 'RUNWORKFLOWONSENDDirectVoucherGreenComFORAPPROVAL';
        RunWorkflowOnCancelDirectVoucherGreenComApprovalCode: label 'RUNWORKFLOWONCANCELDirectVoucherGreenComFORAPPROVAL';
        OnCancelDirectVoucherGreenComApprovalRequestTxt: label 'An Approval Request for Direct Voucher GreenCom has been Cancelled';

        /** Payroll PCA **/

        OnSendPCAApprovalRequestTxt: label 'Approval of a Pay Change Advice is requested';
        RunWorkflowOnSendPCAForApprovalCode: label 'RUNWORKFLOWONSENDPAYCHANGEADVICEFORAPPROVAL';
        OnCancelPCAApprovalRequestTxt: label 'An Approval of a PCA is canceled';
        RunWorkflowOnCancelPCAForApprovalCode: label 'RUNWORKFLOWONCANCELPCAFORAPPROVAL';

        /**Departmental Disposal **/

        OnSendDeptDisposalApprovalRequestTxt: label 'Approval of a Departmental Disposal Plan is requested';
        RunWorkflowOnSendDeptDisposalForApprovalCode: label 'RUNWORKFLOWONSENDDEPTDISPOSALFORAPPROVAL';
        OnCancelDeptDisposalApprovalRequestTxt: label 'An Approval of a Departmental Disposal Plan is canceled';
        RunWorkflowOnCancelDeptDisposalForApprovalCode: label 'RUNWORKFLOWONCANCELDEPTDISPOSALFORAPPROVAL';

        /**Consolidated Disposal **/

        OnSendConsDisposalApprovalRequestTxt: label 'Approval of a Consolidated Disposal Plan is requested';
        RunWorkflowOnSendConsDisposalForApprovalCode: label 'RUNWORKFLOWONSENDDEPTDISPOSALFORAPPROVAL';
        OnCancelConsDisposalApprovalRequestTxt: label 'An Approval of a Consolidated Disposal Plan is canceled';
        RunWorkflowOnCancelConsDisposalForApprovalCode: label 'RUNWORKFLOWONCANCELCONSDISPOSALFORAPPROVAL';

        /** Procurement Committee **/

        OnSendProcCommApprovalRequestTxt: label 'Approval of a Procurement Committee is requested';
        RunWorkflowOnSendProcCommForApprovalCode: label 'RUNWORKFLOWONSENDPROCCOMMFORAPPROVAL';
        OnCancelProcCommApprovalRequestTxt: label 'An Approval of a Procurement Committee is canceled';
        RunWorkflowOnCancelProcCommForApprovalCode: label 'RUNWORKFLOWONCANCELPROCCOMMFORAPPROVAL';

        /* Payment Memo Approval */
        OnSendPaymentMemoApprovalRequestTxt: label 'Approval of a Payment Memo is requested';
        RunWorkflowOnSendPaymentMemoForApprovalCode: label 'RUNWORKFLOWONSENDPAYMENTMEMOFORAPPROVAL';
        OnCancelPaymentMemoApprovalRequestTxt: label 'An Approval of a Payment Memo is canceled';
        RunWorkflowOnCancelPaymentMemoForApprovalCode: label 'RUNWORKFLOWONCANCELPAYMENTMEMOFORAPPROVAL';

    procedure CheckApprovalsWorkflowEnabled(var Variant: Variant): Boolean
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::"Payments Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendPaymentForApprovalCode));
            Database::"HRBack To Office Form":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSend_TrainingEvaluation_ForApprovalCode));
            Database::"InterBank Transfers":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendInterbankForApprovalCode));
            //Database::"Staff Claims Header":
            //      exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffClaimForApprovalCode));
            Database::"Staff Advance Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffAdvanceForApprovalCode));
            Database::"Staff Advance Surrender Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode));
            Database::"Imprest Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendImprestForApprovalCode));
            Database::"Imprest Surrender Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendImprestSurrenderForApprovalCode));
            Database::"Staff Claims Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStaffClaimForApprovalCode));
            //new store
            Database::"Store Requistion Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendStoreRequisitionForApprovalCode));

            Database::"G/L Budget Name":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendBudgetForApprovalCode));
            DATABASE::Workplan:
                EXIT(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendWorkplanForApprovalCode));
            Database::"Vote Transfer":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendVoteForApprovalCode));
            //Investiment
            Database::"Bank Account":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendInvestimentForApprovalCode));
            Database::"prBasic pay PCA":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendPCAForApprovalCode));


            //HR
            //Leave

            Database::"HR Leave Application":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrLeaveForApprovalCode));

            Database::"HR Jobs":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrJobsForApprovalCode));

            DATABASE::"HR Training Applications":
                EXIT(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrTrainingForApprovalCode));

            // Database::"HR Employee Requisitions":
            //     exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendHrEmployeeReqForApprovalCode));

            //  DATABASE::"HR Employee Transfer Header":
            //  EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendHrEmpTransForApprovalCode));

            //  DATABASE::"HR Promo. Recommend Header":
            //  EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendHrPromotionForApprovalCode));

            DATABASE::"FLT-Transport Requisition":
                EXIT(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTransportForApprovalCode));

            // DATABASE::"HR Transport Requisition":
            // EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendHrTransportForApprovalCode));


            // DATABASE::"HR Asset Transfer Header":
            // EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendAssetTransferForApprovalCode));

            // DATABASE::"HR Employee Confirmation":
            //  EXIT(CheckApprovalsWorkflowEnabledCode(Variant,RunWorkflowOnSendHrConfirmationForApprovalCode));

            //HR

            //Academics


            //Academics End
            // Grants
            Database::"Jobs":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendProposalForApprovalCode));
            Database::"Conference Attendance":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendConferenceForApprovalCode));

            //purchase Requisition
            Database::"Purchase Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendPurchaseRequisitionForApprovalCode));
            //Vendor Prequalification
            Database::"Vendor User Buffer":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendVendorBufferForApprovalCode));
            //Transfer Order
            Database::"Transfer Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendTransferOrderForApprovalCode));
            //RFQ
            Database::"Purchase Quote Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendRFQForApprovalCode));

            Database::"Bank Acc. Reconciliation":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendBanksReconForApprovalCode));

            Database::"Imprest Memo Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendImpMemoForApprovalCode));
            Database::"Payment Header GreenCom":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendDirectVoucherGreenComForApprovalCode));

            Database::"Workplan Activities":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendWorkplanActivitiesForApprovalCode));

            Database::"Disposal Plan Header":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendDeptDisposalForApprovalCode));
            Database::"Cons.Disposal Plan":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendConsDisposalForApprovalCode));
            Database::"Tender Committee":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendProcCommForApprovalCode));

            // Payment Memo
            Database::"Payment Memo":
                exit(CheckApprovalsWorkflowEnabledCode(Variant, RunWorkflowOnSendPaymentMemoForApprovalCode));

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;
    end;

    procedure CheckApprovalsWorkflowEnabledCode(var Variant: Variant; CheckApprovalsWorkflowTxt: Text): Boolean
    begin
        begin
            if not WorkflowManagement.CanExecuteWorkflow(Variant, CheckApprovalsWorkflowTxt) then
                Error(NoWorkflowEnabledErr);
            exit(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDocApprovalRequest(var Variant: Variant)
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure AddWorkflowEventsToLibrary()
    var
        WorkFlowEventHandling: Codeunit "Workflow Event Handling";
    begin

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendPaymentForApprovalCode, Database::"Payments Header", OnSendPaymentApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPaymentForApprovalCode, Database::"Payments Header", OnCancelPaymentApprovalRequestTxt, 0, false);
        //Training Evaluation
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSend_TrainingEvaluation_ForApprovalCode, Database::"HRBack To Office Form", OnSend_TrainingEvaluation_ApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancel_TrainingEvaluation_ApprovalCode, Database::"HRBack To Office Form", OnCancel_TrainingEvaluation_ApprovalRequestTxt, 0, false);


        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInterbankForApprovalCode, Database::"InterBank Transfers", OnSendInterbankApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelInterbankForApprovalCode, Database::"InterBank Transfers", OnCancelInterbankApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffClaimForApprovalCode, Database::"Staff Claims Header", OnSendStaffClaimApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffClaimForApprovalCode, Database::"Staff Claims Header", OnCancelStaffClaimApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffAdvanceForApprovalCode, Database::"Staff Advance Header", OnSendStaffAdvanceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffAdvanceForApprovalCode, Database::"Staff Advance Header", OnCancelStaffAdvanceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode, Database::"Staff Advance Surrender Header", OnSendStaffAdvanceSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode, Database::"Staff Advance Surrender Header", OnCancelStaffAdvanceSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendImprestForApprovalCode, Database::"Imprest Header", OnSendImprestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImprestForApprovalCode, Database::"Imprest Header", OnCancelImprestApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendImprestSurrenderForApprovalCode, Database::"Imprest Surrender Header", OnSendImprestSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImprestSurrenderForApprovalCode, Database::"Imprest Surrender Header", OnCancelImprestSurrenderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendPCAForApprovalCode, Database::"prBasic pay PCA", OnSendPCAApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPCAForApprovalCode, Database::"prBasic pay PCA", OnCancelPCAApprovalRequestTxt, 0, false);
        //new store
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStoreRequisitionForApprovalCode, Database::"Store Requistion Header", OnSendStoreRequisitionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStoreRequisitionForApprovalCode, Database::"Store Requistion Header", OnCancelStoreRequisitionApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendStaffClaimForApprovalCode, Database::"Staff Claims Header", OnSendStaffClaimApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelStaffClaimForApprovalCode, Database::"Staff Claims Header", OnCancelStaffClaimApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendBudgetForApprovalCode, Database::"G/L Budget Name", OnSendBudgetApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelBudgetForApprovalCode, Database::"G/L Budget Name", OnCancelBudgetApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendWorkplanForApprovalCode, DATABASE::Workplan, OnSendWorkplanApprovalRequestTxt, 0, FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelWorkplanForApprovalCode, DATABASE::Workplan, OnCancelWorkplanApprovalRequestTxt, 0, FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendVoteForApprovalCode, Database::"Vote Transfer", OnSendVoteApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelVoteForApprovalCode, Database::"Vote Transfer", OnCancelVoteApprovalRequestTxt, 0, false);
        //Investiment
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendInvestimentForApprovalCode, Database::"Bank Account", OnSendInvestimentApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelInvestimentForApprovalCode, Database::"Bank Account", OnCancelInvestimentApprovalRequestTxt, 0, false);


        //HR

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrLeaveForApprovalCode, Database::"HR Leave Application", OnSendHrLeaveApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrLeaveForApprovalCode, Database::"HR Leave Application", OnCancelHrLeaveApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrJobsForApprovalCode, Database::"HR Jobs", OnSendHrJobsApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrJobsForApprovalCode, Database::"HR Jobs", OnCancelHrJobsApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrTrainingForApprovalCode, DATABASE::"HR Training Applications", OnSendHrTrainingApprovalRequestTxt, 0, FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrTrainingForApprovalCode, DATABASE::"HR Training Applications", OnCancelHrTrainingApprovalRequestTxt, 0, FALSE);


        // WorkFlowEventHandling.AddEventToLibrary(
        // RunWorkflowOnSendHrEmployeeReqForApprovalCode, Database::"HR Employee Requisitions", OnSendHrEmployeeReqApprovalRequestTxt, 0, false);
        // WorkFlowEventHandling.AddEventToLibrary(
        //RunWorkflowOnCancelHrEmployeeReqForApprovalCode, Database::"HR Employee Requisitions", OnCancelHrEmployeeReqApprovalRequestTxt, 0, false);
        /*
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrEmpTransForApprovalCode,DATABASE::"HR Employee Transfer Header",OnSendHrEmpTransApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrEmpTransForApprovalCode,DATABASE::"HR Employee Transfer Header",OnCancelHrEmpTransApprovalRequestTxt,0,FALSE);
        
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrPromotionForApprovalCode,DATABASE::"HR Promo. Recommend Header",OnSendHrPromotionApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrPromotionForApprovalCode,DATABASE::"HR Promo. Recommend Header",OnCancelHrPromotionApprovalRequestTxt,0,FALSE);
        
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrTransportForApprovalCode,DATABASE::"HR Transport Requisition",OnSendHrTransportApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrTransportForApprovalCode,DATABASE::"HR Transport Requisition",OnCancelHrTransportApprovalRequestTxt,0,FALSE);
        
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendAssetTransferForApprovalCode,DATABASE::"HR Asset Transfer Header",OnSendAssetTransferApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelAssetTransferForApprovalCode,DATABASE::"HR Asset Transfer Header",OnCancelAssetTransferApprovalRequestTxt,0,FALSE);
        
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendHrConfirmationForApprovalCode,DATABASE::"HR Employee Confirmation",OnSendHrConfirmationApprovalRequestTxt,0,FALSE);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelHrConfirmationForApprovalCode,DATABASE::"HR Employee Confirmation",OnCancelHrConfirmationApprovalRequestTxt,0,FALSE);
        */
        //HR

        //------Academics
        //Academics End
        //Fleet
        WorkFlowEventHandling.AddEventToLibrary(
       RunWorkflowOnSendTransportForApprovalCode, Database::"FLT-Transport Requisition", OnSendTransportApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTransportApprovalCode, Database::"FLT-Transport Requisition", OnCancelTransportApprovalRequestTxt, 0, false);
        //Grants
        WorkFlowEventHandling.AddEventToLibrary(
              RunWorkflowOnSendProposalForApprovalCode, Database::Jobs, OnSendProposalApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelProposalApprovalCode, Database::Jobs, OnCancelProposalApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
                     RunWorkflowOnSendConferenceForApprovalCode, Database::"Conference Attendance", OnSendConferenceApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelConferenceApprovalCode, Database::"Conference Attendance", OnCancelConferenceApprovalRequestTxt, 0, false);
        //purchase requsition
        WorkFlowEventHandling.AddEventToLibrary(
       RunWorkflowOnSendPurchaseRequisitionForApprovalCode, Database::"Purchase Header", OnSendPurchaseRequisitionApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPurchaseRequisitionApprovalCode, Database::"Purchase Header", OnCancelPurchaseRequisitionApprovalRequestTxt, 0, false);
        //Vendor Prequalification
        WorkFlowEventHandling.AddEventToLibrary(
       RunWorkflowOnSendVendorBufferForApprovalCode, Database::"Vendor User Buffer", OnSendVendorBufferApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelVendorBufferApprovalCode, Database::"Vendor User Buffer", OnCancelVendorBufferApprovalRequestTxt, 0, false);

        WorkFlowEventHandling.AddEventToLibrary(
                                RunWorkflowOnCancelTransferOrderApprovalCode, Database::"Transfer Header", OnCancelTransferOrderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
                             RunWorkflowOnSendTransferOrderForApprovalCode, Database::"Transfer Header", OnSendTransferOrderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelTransferOrderApprovalCode, Database::"Transfer Header", OnCancelTransferOrderApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
                             RunWorkflowOnSendTransferOrderForApprovalCode, Database::"Transfer Header", OnSendTransferOrderApprovalRequestTxt, 0, false);

        //rfq
        WorkFlowEventHandling.AddEventToLibrary(
       RunWorkflowOnSendRFQForApprovalCode, Database::"Purchase Quote Header", OnSendRFQApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelRFQApprovalCode, Database::"Purchase Quote Header", OnCancelRFQApprovalRequestTxt, 0, false);
        //Bank Recon
        WorkFlowEventHandling.AddEventToLibrary(
          RunWorkflowOnSendBanksReconForApprovalCode, DATABASE::"Bank Acc. Reconciliation", OnSendBanksReconApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnSendBanksReconForApprovalCode, DATABASE::"Bank Acc. Reconciliation", OnCancelBanksReconApprovalRequestTxt, 0, false);
        //Imprest memo
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendImpMemoForApprovalCode, Database::"Imprest Memo Header", OnSendImpMemoApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelImpMemoApprovalCode, Database::"Imprest Memo Header", OnCancelImpMemoApprovalRequestTxt, 0, false);

        // DirectVoucherGreenCom
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendDirectVoucherGreenComForApprovalCode, Database::"Payment Header GreenCom", OnSendDirectVoucherGreenComApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelDirectVoucherGreenComApprovalCode, Database::"Payment Header GreenCom", OnCancelDirectVoucherGreenComApprovalRequestTxt, 0, false);

        //Workplan Activities
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendWorkplanActivitiesForApprovalCode, Database::"Workplan Activities", OnSendWorkplanActivitiesApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelWorkplanActivitiesForApprovalCode, Database::"Workplan Activities", OnCancelWorkplanActivitiesApprovalRequestTxt, 0, false);

        //Departmental Disposal Plan
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendDeptDisposalForApprovalCode, Database::"Disposal Plan Header", OnSendDeptDisposalApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelDeptDisposalForApprovalCode, Database::"Disposal Plan Header", OnCancelDeptDisposalApprovalRequestTxt, 0, false);

        //Consolodated Disposal Plan
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendConsDisposalForApprovalCode, Database::"Cons.Disposal Plan", OnSendConsDisposalApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelConsDisposalForApprovalCode, Database::"Cons.Disposal Plan", OnCancelConsDisposalApprovalRequestTxt, 0, false);

        //Procurement Committee
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendProcCommForApprovalCode, Database::"Tender Committee", OnSendProcCommApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelProcCommForApprovalCode, Database::"Tender Committee", OnCancelProcCommApprovalRequestTxt, 0, false);

        // Payment Memo
        WorkFlowEventHandling.AddEventToLibrary(
         RunWorkflowOnSendPaymentMemoForApprovalCode, Database::"Payment Memo", OnSendPaymentMemoApprovalRequestTxt, 0, false);
        WorkFlowEventHandling.AddEventToLibrary(
        RunWorkflowOnCancelPaymentMemoForApprovalCode, Database::"Payment Memo", OnCancelPaymentMemoApprovalRequestTxt, 0, false);

    end;

    local procedure RunWorkflowOnSendApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals Codeunit", 'OnSendDocForApproval', '', false, false)]
    procedure RunWorkflowOnSendApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin


        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::"Payments Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentForApprovalCode, Variant);

            Database::"HRBack To Office Form":
                WorkflowManagement.HandleEvent(RunWorkflowOnSend_TrainingEvaluation_ForApprovalCode, Variant);

            Database::"InterBank Transfers":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendInterbankForApprovalCode, Variant);
            Database::"Staff Claims Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffClaimForApprovalCode, Variant);
            Database::"Staff Advance Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffAdvanceForApprovalCode, Variant);
            Database::"Staff Advance Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStaffAdvanceSurrenderForApprovalCode, Variant);
            Database::"Imprest Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestForApprovalCode, Variant);
            Database::"Imprest Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestSurrenderForApprovalCode, Variant);
            //new store
            Database::"Store Requistion Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendStoreRequisitionForApprovalCode, Variant);
            Database::"prBasic pay PCA":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendPCAForApprovalCode, Variant);

            //DATABASE::"Staff Claims Header":
            //   WorkflowManagement.HandleEvent(RunWorkflowOnSendOvertimeForApprovalCode,Variant);
            Database::"G/L Budget Name":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendBudgetForApprovalCode, Variant);
            DATABASE::Workplan:
                WorkflowManagement.HandleEvent(RunWorkflowOnSendWorkplanForApprovalCode, Variant);
            Database::"Vote Transfer":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendVoteForApprovalCode, Variant);
            //Investiment
            Database::"Bank Account":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendInvestimentForApprovalCode, Variant);
            //HR

            Database::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrLeaveForApprovalCode, Variant);

            Database::"HR Jobs":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrJobsForApprovalCode, Variant);

            Database::"HR Employee Requisitions":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrEmployeeReqForApprovalCode, Variant);


            DATABASE::"HR Training Applications":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendHrTrainingForApprovalCode, Variant);

            /*
             DATABASE::"HR Employee Transfer Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendHrEmpTransForApprovalCode,Variant);

             DATABASE::"HR Promo. Recommend Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendHrPromotionForApprovalCode,Variant);

             DATABASE::"HR Transport Requisition":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendHrTransportForApprovalCode,Variant);

             DATABASE::"HR Asset Transfer Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendAssetTransferForApprovalCode,Variant);

             DATABASE::"HR Employee Confirmation":
             WorkflowManagement.HandleEvent(RunWorkflowOnSendHrConfirmationForApprovalCode,Variant);
             */
            //HR

            Database::"FLT-Transport Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTransportForApprovalCode, Variant);

            //Grants
            Database::Jobs:
                WorkflowManagement.HandleEvent(RunWorkflowOnSendProposalForApprovalCode, Variant);

            Database::"Conference Attendance":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendConferenceForApprovalCode, Variant);

            //Purchase Requisition
            Database::"Purchase Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseRequisitionForApprovalCode, Variant);

            //Vendor Prequalification
            Database::"Vendor User Buffer":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendVendorBufferForApprovalCode, Variant);

            Database::"Transfer Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendTransferOrderForApprovalCode, Variant);

            //RFQ

            Database::"Purchase Quote Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendRFQForApprovalCode, Variant);

            //Bank Recon
            Database::"Bank Acc. Reconciliation":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendBanksReconForApprovalCode, Variant);
            //memo
            Database::"Imprest Memo Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendImpMemoForApprovalCode, Variant);
            //DirectVoucherGreenCom
            Database::"Payment Header GreenCom":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendDirectVoucherGreenComForApprovalCode, Variant);
            //Workplan Activities
            Database::"Workplan Activities":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendWorkplanActivitiesForApprovalCode, Variant);
            //Departmental Disposal Plan
            Database::"Disposal Plan Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendDeptDisposalForApprovalCode, Variant);
            //Consolidated Disposal Plan
            Database::"Cons.Disposal Plan":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendConsDisposalForApprovalCode, Variant);

            //Procurement Committee
            Database::"Tender Committee":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendProcCommForApprovalCode, Variant);

            // Payment Memo
            Database::"Payment Memo":
                WorkflowManagement.HandleEvent(RunWorkflowOnSendPaymentMemoForApprovalCode, Variant);

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Custom Approvals Codeunit", 'OnCancelDocApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelApprovalRequest(var Variant: Variant)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            Database::"Payments Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentForApprovalCode, Variant);

            Database::"HRBack To Office Form":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancel_TrainingEvaluation_ApprovalCode, Variant);

            Database::"InterBank Transfers":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelInterbankForApprovalCode, Variant);
            Database::"Staff Claims Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffClaimForApprovalCode, Variant);
            Database::"Staff Advance Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffAdvanceForApprovalCode, Variant);
            Database::"Staff Advance Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffAdvanceSurrenderForApprovalCode, Variant);
            Database::"Imprest Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestForApprovalCode, Variant);
            Database::"Imprest Surrender Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestSurrenderForApprovalCode, Variant);
            //new store
            Database::"Store Requistion Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelStoreRequisitionForApprovalCode, Variant);
            Database::"prBasic pay PCA":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPCAForApprovalCode, Variant);

            // DATABASE::"Staff Claims Header":
            //  WorkflowManagement.HandleEvent(RunWorkflowOnCancelStaffClaimForApprovalCode,Variant);
            Database::"G/L Budget Name":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelBudgetForApprovalCode, Variant);
            DATABASE::Workplan:
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelWorkplanForApprovalCode, Variant);
            Database::"Vote Transfer":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelVoteForApprovalCode, Variant);
            //Investiment
            Database::"Bank Account":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelInvestimentForApprovalCode, Variant);
            //HR
            Database::"HR Leave Application":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrLeaveForApprovalCode, Variant);
            Database::"HR Jobs":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrJobsForApprovalCode, Variant);

            Database::"HR Employee Requisitions":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrEmployeeReqForApprovalCode, Variant);


            DATABASE::"HR Training Applications":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrTrainingForApprovalCode, Variant);

            /*
             DATABASE::"HR Employee Transfer Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrEmpTransForApprovalCode,Variant);
             DATABASE::"HR Promo. Recommend Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrPromotionForApprovalCode,Variant);
             DATABASE::"HR Transport Requisition":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrTransportForApprovalCode,Variant);
             DATABASE::"HR Asset Transfer Header":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelAssetTransferForApprovalCode,Variant);
             DATABASE::"HR Employee Confirmation":
             WorkflowManagement.HandleEvent(RunWorkflowOnCancelHrConfirmationForApprovalCode,Variant);
             */
            //HR

            //Academics
            Database::"FLT-Transport Requisition":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTransportApprovalCode, Variant);
            Database::Jobs:
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelProposalApprovalCode, Variant);
            Database::"Conference Attendance":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelConferenceApprovalCode, Variant);
            //Purchase Requisition
            Database::"Purchase Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseRequisitionApprovalCode, Variant);
            //Vendor Prequalification
            Database::"Vendor User Buffer":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelVendorBufferApprovalCode, Variant);
            Database::"Transfer Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelTransferOrderApprovalCode, Variant);
            //RFQ
            Database::"Purchase Quote Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelRFQApprovalCode, Variant);

            //imprest memo
            Database::"Imprest Memo Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelImpMemoApprovalCode, Variant);
            //DirectVoucherGreenCom
            Database::"Payment Header GreenCom":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelDirectVoucherGreenComApprovalCode, Variant);
            //Bank Recon
            Database::"Bank Acc. Reconciliation":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelBanksReconForApprovalCode, Variant);

            //Workplan Activities
            Database::"Workplan Activities":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelWorkplanActivitiesForApprovalCode, Variant);

            //Departmenal Disposal
            Database::"Disposal Plan Header":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelDeptDisposalForApprovalCode, Variant);

            //Consolidated Disposal
            Database::"Cons.Disposal Plan":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelConsDisposalForApprovalCode, Variant);
            //Procurement Committee
            Database::"Tender Committee":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelProcCommForApprovalCode, Variant);

            // Payment Memo
            Database::"Payment Memo":
                WorkflowManagement.HandleEvent(RunWorkflowOnCancelPaymentMemoForApprovalCode, Variant);

            //Academics
            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end;

    end;

    procedure ReOpen(var RecRef: RecordRef; Handled: Boolean)
    var
        //  RecRef: RecordRef;
        Variant: Variant;
        PaymentsHeader: Record "Payments Header";
        StaffClaimsHeader: Record "Staff Claims Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        Vote: Record "Vote Transfer";
        HRLeaveApp: Record "HR Leave Application";
        Hrjobs: Record "HR Jobs";
        HrTraining: Record "HR Training Applications";
        HrReq: Record "HR Employee Requisitions";
        Transport: Record "FLT-Transport Requisition";
        Job: Record Jobs;
        Conference: Record "Conference Attendance";
        PurchaseHeader: Record "Purchase Header";
        VendorBuffer: Record "Vendor User Buffer";
        TransHeader: record "Transfer Header";
        HRBackToOffice: Record "HRBack To Office Form";
        RFQ: Record "Purchase Quote Header";
        BankRecon: Record "Bank Acc. Reconciliation";
        Workplan: Record Workplan;
        WorkplanActivities: Record "Workplan Activities";
        ImpMemo: Record "Imprest Memo Header";
        DirectVoucherGreenCom: Record "Payment Header GreenCom";
        PCA: Record "prBasic pay PCA";
        DeptDisposal: Record "Disposal Plan Header";
        ConsDisposal: Record "Cons.Disposal Plan";
        ProcCommittee: Record "Tender Committee";
        PaymentMemo: Record "Payment Memo";

    begin
        // RecRef.GetTable(Variant);
        case RecRef.Number of

            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApp);
                    HRLeaveApp.Validate(Status, HRLeaveApp.Status::Open);
                    HRLeaveApp.Modify;
                    Variant := HRLeaveApp;
                    Handled := true;
                end;
            Database::"HRBack To Office Form":
                begin
                    RecRef.SetTable(HRBackToOffice);
                    HRBackToOffice.Validate(Status, HRBackToOffice.Status::New);
                    HRBackToOffice.Modify;
                    Variant := HRBackToOffice;
                    Handled := true;
                end;

            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentsHeader);
                    PaymentsHeader.Validate(Status, PaymentsHeader.Status::Pending);
                    PaymentsHeader.Modify;
                    Variant := PaymentsHeader;
                    Handled := true;
                end;

            Database::"Staff Claims Header":
                begin
                    RecRef.SetTable(StaffClaimsHeader);
                    StaffClaimsHeader.Validate(Status, StaffClaimsHeader.Status::Pending);
                    StaffClaimsHeader.Modify;
                    Variant := StaffClaimsHeader;
                    Handled := true;
                end;
            Database::"Staff Advance Header":
                begin
                    RecRef.SetTable(StaffAdvanceHeader);
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::Pending);
                    StaffAdvanceHeader.Modify;
                    Variant := StaffAdvanceHeader;
                    Handled := true;
                end;
            Database::"Staff Advance Surrender Header":
                begin
                    RecRef.SetTable(StaffAdvanceSurrenderHeader);
                    StaffAdvanceSurrenderHeader.Validate(Status, StaffAdvanceSurrenderHeader.Status::Pending);
                    StaffAdvanceSurrenderHeader.Modify;
                    Variant := StaffAdvanceSurrenderHeader;
                    Handled := true;
                end;
            Database::"Imprest Header":
                begin
                    RecRef.SetTable(ImprestHeader);
                    ImprestHeader.Validate(Status, ImprestHeader.Status::Pending);
                    ImprestHeader.Modify;
                    Variant := ImprestHeader;
                    Handled := true;
                end;
            Database::"prBasic pay PCA":
                begin
                    RecRef.SetTable(PCA);
                    ImprestHeader.Validate(Status, PCA.Status::Open);
                    ImprestHeader.Modify;
                    Variant := PCA;
                    Handled := true;
                end;
            Database::"Imprest Surrender Header":
                begin
                    RecRef.SetTable(ImprestSurrenderHeader);
                    ImprestSurrenderHeader.Validate(Status, ImprestSurrenderHeader.Status::Pending);
                    ImprestSurrenderHeader.Modify;
                    Variant := ImprestSurrenderHeader;
                    Handled := true;
                end;

            //new store
            Database::"Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequistionHeader);
                    StoreRequistionHeader.Validate(Status, StoreRequistionHeader.Status::Open);
                    StoreRequistionHeader.Modify;
                    Variant := StoreRequistionHeader;
                    Handled := true;
                end;

            Database::"InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);
                    InterBankTransfers.Validate(Status, InterBankTransfers.Status::Pending);
                    InterBankTransfers.Modify;
                    Variant := InterBankTransfers;
                    Handled := true;
                end;
            /*
                        Database::"Staff Claims Header":
                            begin
                                RecRef.SetTable(OvertimeClaimHeader);
                                OvertimeClaimHeader.Validate(Status, OvertimeClaimHeader.Status::Pending);
                                OvertimeClaimHeader.Modify;
                                Variant := OvertimeClaimHeader;
                            end;
            */
            // Database::"HR Leave Application":
            //     begin
            //         RecRef.SetTable(Hrleave);
            //         Hrleave.Validate(Status, Hrleave.Status::Open);
            //         Hrleave.Modify;
            //         Variant := Hrleave;
            //         Handled := true;
            //     end;
            /*
              DATABASE::"G/L Budget Name":
                BEGIN
                 RecRef.SETTABLE(Budget);
                 Budget.VALIDATE(Status,Budget.Status::"0");
                 Budget.MODIFY;
                 Variant := Budget;
                END;
            */
            DATABASE::Workplan:
                BEGIN
                    RecRef.SETTABLE(Workplan);
                    Workplan.VALIDATE(Status, Workplan.Status::Open);
                    Workplan.MODIFY;
                    Variant := Workplan;
                END;

            DATABASE::"Workplan Activities":
                BEGIN
                    RecRef.SETTABLE(WorkplanActivities);
                    WorkplanActivities.VALIDATE(Status, WorkplanActivities.Status::Open);
                    WorkplanActivities.MODIFY;
                    Variant := WorkplanActivities;
                END;


            Database::"Vote Transfer":
                begin
                    RecRef.SetTable(Vote);
                    Vote.Validate(Status, Vote.Status::Open);
                    Vote.Modify;
                    Variant := Vote;
                    Handled := true;
                end;
            /*
            //Investiment
              DATABASE::"Bank Account":
               BEGIN
               RecRef.SETTABLE(Invest);
              Invest.VALIDATE(Status,Invest.Status::Open);
              Invest.MODIFY;
              Variant:=Invest;
              END;
            //HR
            */


            Database::"HR Jobs":
                begin
                    RecRef.SetTable(Hrjobs);
                    Hrjobs.Validate(Status, Hrjobs.Status::New);
                    Hrjobs.Modify;
                    Variant := Hrjobs;
                    Handled := true;
                end;

            Database::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(HrReq);
                    HrReq.Validate(Status, HrReq.Status::New);
                    HrReq.Modify;
                    Variant := HrReq;
                    Handled := true;
                end;

            DATABASE::"HR Training Applications":
                BEGIN
                    RecRef.SETTABLE(HrTraining);
                    HrTraining.VALIDATE(Status, HrTraining.Status::New);
                    HrTraining.MODIFY;
                    Variant := HrTraining;
                    Handled := true;
                END;
            /*
            DATABASE::"HR Employee Transfer Header":
            BEGIN
                 RecRef.SETTABLE(HrEmpTrans);
                HrEmpTrans.VALIDATE(Status,HrEmpTrans.Status::New);
                HrEmpTrans.MODIFY;
                 Variant := HrEmpTrans;
                END;

            DATABASE::"HR Promo. Recommend Header":
            BEGIN
                 RecRef.SETTABLE(HrPromo);
                HrPromo.VALIDATE(Status,HrPromo.Status::New);
                HrPromo.MODIFY;
                 Variant := HrPromo;
                END;
            DATABASE::"HR Transport Requisition":
            BEGIN
                 RecRef.SETTABLE(HrTransport);
                HrTransport.VALIDATE(Status,HrTransport.Status::New);
                HrTransport.MODIFY;
                 Variant := HrTransport;
                END;

             DATABASE::"HR Asset Transfer Header":
             BEGIN
                 RecRef.SETTABLE(HrAssetTrans);
                HrAssetTrans.VALIDATE(Status,HrAssetTrans.Status::New);
                HrAssetTrans.MODIFY;
                 Variant := HrAssetTrans;
                END;

            DATABASE::"HR Employee Confirmation":

            BEGIN
                 RecRef.SETTABLE(HrEmpConfirm);
                HrEmpConfirm.VALIDATE(Status,HrEmpConfirm.Status::New);
                HrEmpConfirm.MODIFY;
                 Variant := HrEmpConfirm;
                END;
              */
            //HR

            //Academics-------------------

            Database::"FLT-Transport Requisition":
                begin
                    RecRef.SetTable(Transport);
                    Transport.Validate(Status, Transport.Status::Open);
                    Transport.Modify;
                    Variant := Transport;
                    Handled := true;
                end;
            Database::Jobs:
                begin
                    RecRef.SetTable(Job);
                    Job.Validate(Job."Approval Status", Job."Approval Status"::Open);
                    Job.Modify;
                    Variant := Job;
                    Handled := true;
                end;
            Database::"Conference Attendance":
                begin
                    RecRef.SetTable(Conference);
                    Conference.Validate(Conference."Status", Conference."Status"::New);
                    Conference.Modify;
                    Variant := Conference;
                    Handled := true;
                end;
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    PurchaseHeader.Validate(PurchaseHeader."Status", PurchaseHeader."Status"::Open);
                    PurchaseHeader.Modify;
                    Variant := PurchaseHeader;
                    Handled := true;
                end;

            Database::"Vendor User Buffer":
                begin
                    RecRef.SetTable(VendorBuffer);
                    VendorBuffer.Validate(VendorBuffer."Status", VendorBuffer."Status"::New);
                    VendorBuffer.Modify;
                    Variant := VendorBuffer;
                    Handled := true;
                end;
            Database::"Transfer Header":
                begin
                    RecRef.SetTable(TransHeader);
                    TransHeader.Validate(TransHeader."Approval Status", TransHeader."Approval Status"::Open);
                    TransHeader.Modify;
                    Variant := TransHeader;
                    Handled := true;
                end;

            Database::"Purchase Quote Header":
                begin
                    RecRef.SetTable(RFQ);
                    RFQ.Validate(RFQ.Status, RFQ.Status::Open);
                    RFQ.Modify;
                    Variant := RFQ;
                    Handled := true;
                end;
            Database::"Bank Acc. Reconciliation":
                begin
                    RecRef.SetTable(BankRecon);
                    BankRecon.Validate(BankRecon.Status, BankRecon.Status::Pending);
                    BankRecon.Modify;
                    Variant := BankRecon;
                    Handled := true;
                end;
            Database::"Imprest Memo Header":
                begin
                    RecRef.SetTable(ImpMemo);
                    ImpMemo.Validate(ImpMemo.Status, ImpMemo.Status::Pending);
                    ImpMemo.Modify;
                    Variant := ImpMemo;
                    Handled := true;
                end;
            //DirectVoucherGreenCom
            Database::"Payment Header GreenCom":
                begin
                    RecRef.SetTable(DirectVoucherGreenCom);
                    DirectVoucherGreenCom.Validate(DirectVoucherGreenCom.Status, DirectVoucherGreenCom.Status::Open);
                    DirectVoucherGreenCom.Modify;
                    Variant := DirectVoucherGreenCom;
                    Handled := true;
                end;
            Database::"Disposal Plan Header":
                begin
                    RecRef.SetTable(DeptDisposal);
                    DeptDisposal.Validate(DeptDisposal.Status, DeptDisposal.Status::Open);
                    DeptDisposal.Modify;
                    Variant := DeptDisposal;
                    Handled := true;
                end;
            Database::"Cons.Disposal Plan":
                begin
                    RecRef.SetTable(ConsDisposal);
                    ConsDisposal.Validate(ConsDisposal.Status, ConsDisposal.Status::Pending);
                    ConsDisposal.Modify;
                    Variant := ConsDisposal;
                    Handled := true;
                end;
            Database::"Tender Committee":
                begin
                    RecRef.SetTable(ProcCommittee);
                    ProcCommittee.Validate(ProcCommittee.Status, ProcCommittee.Status::Open);
                    ProcCommittee.Modify;
                    Variant := ProcCommittee;
                    Handled := true;
                end;
            Database::"Payment Memo":
                begin
                    RecRef.SetTable(PaymentMemo);
                    PaymentMemo.Validate(PaymentMemo.Status, PaymentMemo.Status::Open);
                    PaymentMemo.Modify;
                    Variant := PaymentMemo;
                    Handled := true;
                end;

            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);
        end

    end;

    procedure Release(RecRef: RecordRef; var Handled: Boolean)
    var
        // RecRef: RecordRef;
        Variant: Variant;
        PaymentsHeader: Record "Payments Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        OvertimeClaimHeader: Record "Staff Claims Header";
        Vote: Record "Vote Transfer";
        HRLeaveApp: Record "HR Leave Application";
        HrTraining: Record "HR Training Applications";
        HrReq: Record "HR Employee Requisitions";

        Transport: Record "FLT-Transport Requisition";
        Job: Record Jobs;
        Conference: Record "Conference Attendance";
        PurchaseHeader: Record "Purchase Header";
        VendorBuffer: Record "Vendor User Buffer";
        TransHeader: Record "Transfer Header";
        HRBackToOffice: Record "HRBack To Office Form";
        RFQ: Record "Purchase Quote Header";
        BankRecon: Record "Bank Acc. Reconciliation";
        Workplan: Record Workplan;
        WorkplanActivities: Record "Workplan Activities";
        ImpMemo: Record "Imprest Memo Header";
        DirectVoucherGreenCom: Record "Payment Header GreenCom";
        PCA: Record "prBasic pay PCA";
        DeptDisposal: Record "Disposal Plan Header";
        ConsDisposal: Record "Cons.Disposal Plan";
        ProcCommittee: Record "Tender Committee";
        PaymentMemo: Record "Payment Memo";
    begin
        Handled := true;
        // RecRef.GetTable(Variant);
        case RecRef.Number of

            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApp);
                    HRLeaveApp.Validate(Status, HRLeaveApp.Status::Approved);
                    HRLeaveApp.Modify();
                    HRLeaveApp.Validate(Status);
                    Variant := HRLeaveApp;
                end;


            Database::"HRBack To Office Form":
                begin
                    RecRef.SetTable(HRBackToOffice);
                    HRBackToOffice.Validate(Status, HRBackToOffice.Status::Approved);
                    HRBackToOffice.Modify;
                    HRBackToOffice.Validate(Status);
                    Variant := HRBackToOffice;
                end;

            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentsHeader);
                    PaymentsHeader.Validate(Status, PaymentsHeader.Status::Approved);
                    PaymentsHeader.Modify;
                    Variant := PaymentsHeader;
                end;
            /*
        Database::"Staff Claims Header":
            begin
                RecRef.SetTable(StaffClaimsHeader);
                StaffClaimsHeader.Validate(Status, StaffClaimsHeader.Status::Approved);
                StaffClaimsHeader.Modify;
                Variant := StaffClaimsHeader;
            end;
            */
            Database::"Staff Advance Header":
                begin
                    RecRef.SetTable(StaffAdvanceHeader);
                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::Approved);
                    StaffAdvanceHeader.Modify;
                    Variant := StaffAdvanceHeader;
                end;
            Database::"Staff Advance Surrender Header":
                begin
                    RecRef.SetTable(StaffAdvanceSurrenderHeader);
                    StaffAdvanceSurrenderHeader.Validate(Status, StaffAdvanceSurrenderHeader.Status::Approved);
                    StaffAdvanceSurrenderHeader.Modify;
                    Variant := StaffAdvanceSurrenderHeader;
                end;
            Database::"Imprest Header":
                begin
                    RecRef.SetTable(ImprestHeader);
                    ImprestHeader.Validate(Status, ImprestHeader.Status::Approved);
                    ImprestHeader.Modify;
                    Variant := ImprestHeader;
                end;
            Database::"prBasic pay PCA":
                begin
                    RecRef.SetTable(PCA);
                    ImprestHeader.Validate(Status, PCA.Status::Approved);
                    PCA.Modify;
                    Variant := PCA;
                end;
            Database::"Imprest Surrender Header":
                begin
                    RecRef.SetTable(ImprestSurrenderHeader);
                    ImprestSurrenderHeader.Validate(Status, ImprestSurrenderHeader.Status::Approved);
                    ImprestSurrenderHeader.Modify;
                    Variant := ImprestSurrenderHeader;
                end;
            //new store
            Database::"Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequistionHeader);
                    StoreRequistionHeader.Validate(Status, StoreRequistionHeader.Status::Released);
                    StoreRequistionHeader.Modify;
                    Variant := StoreRequistionHeader;
                end;
            Database::"InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);
                    InterBankTransfers.Validate(Status, InterBankTransfers.Status::Approved);
                    InterBankTransfers.Modify;
                    Variant := InterBankTransfers;
                end;
            Database::"Staff Claims Header":
                begin
                    RecRef.SetTable(OvertimeClaimHeader);
                    OvertimeClaimHeader.Validate(Status, OvertimeClaimHeader.Status::Approved);
                    OvertimeClaimHeader.Modify;
                    Variant := OvertimeClaimHeader;
                end;

            // Database::"HR Leave Application":
            //     begin
            //         RecRef.SetTable(Hrleave);
            //         Hrleave.Validate(Status, Hrleave.Status::Approved);
            //         Hrleave.Modify;
            //         Hrleave.fn_PostLeaveApplication(Hrleave."Application Code");
            //         Variant := Hrleave;
            //     end;
            /*
            DATABASE::"G/L Budget Name":
              BEGIN
               RecRef.SETTABLE(Budget);
               Budget.VALIDATE(Status,Budget.Status::"2");
               Budget.MODIFY;
               Variant := Budget;
              END;
              */
            DATABASE::Workplan:
                BEGIN
                    RecRef.SETTABLE(Workplan);
                    Workplan.VALIDATE(Status, Workplan.Status::Approved);
                    Workplan.MODIFY;
                    Variant := Workplan;
                END;

            DATABASE::"Workplan Activities":
                BEGIN
                    RecRef.SETTABLE(WorkplanActivities);
                    WorkplanActivities.VALIDATE(Status, WorkplanActivities.Status::Approved);
                    WorkplanActivities.MODIFY;
                    Variant := WorkplanActivities;
                END;

            Database::"Vote Transfer":
                begin
                    RecRef.SetTable(Vote);
                    Vote.Validate(Status, Vote.Status::Approved);
                    Vote.Modify;
                    Variant := Vote;
                end;

            /*
            //Investiment
              DATABASE::"Bank Account":
               BEGIN
               RecRef.SETTABLE(Invest);
              Invest.VALIDATE(Status,Invest.Status::Approved);
              Invest.MODIFY;
              Variant:=Invest;
              END;
                //Hr
            */


            Database::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(HrReq);
                    HrReq.Validate(Status, HrReq.Status::Approved);
                    HrReq.Modify;
                    Variant := HrReq;
                end;
            /*
             DATABASE::"HR Jobs":
              BEGIN
                 RecRef.SETTABLE(Hrjobs);
                 Hrjobs.VALIDATE(Status,Hrjobs.Status::Approved);
                 Hrjobs.MODIFY;
                 Variant := Hrjobs;
                END;
            */
            DATABASE::"HR Training Applications":
                BEGIN
                    RecRef.SETTABLE(HrTraining);
                    HrTraining.VALIDATE(Status, HrTraining.Status::Approved);
                    HrTraining.MODIFY;
                    Variant := HrTraining;
                END;
            /*

            DATABASE::"HR Employee Transfer Header":
            BEGIN
             RecRef.SETTABLE(HrEmpTrans);
             HrEmpTrans.VALIDATE(Status,HrEmpTrans.Status::Approved);
             HrEmpTrans.MODIFY;
             Variant := HrEmpTrans;
             END;
             DATABASE::"HR Promo. Recommend Header":
             BEGIN
             RecRef.SETTABLE(HrPromo);
             HrPromo.VALIDATE(Status,HrPromo.Status::Approved);
             HrPromo.MODIFY;
             Variant := HrPromo;
            END;
            DATABASE::"HR Transport Requisition":
            BEGIN
             RecRef.SETTABLE(HrTransport);
             HrTransport.VALIDATE(Status,HrTransport.Status::Approved);
             HrTransport.MODIFY;
             Variant := HrTransport;
            END;
            DATABASE::"HR Asset Transfer Header":
            BEGIN
             RecRef.SETTABLE(HrAssetTrans);
             HrAssetTrans.VALIDATE(Status,HrAssetTrans.Status::Approved);
             HrAssetTrans.MODIFY;
             Variant := HrAssetTrans;
            END;

         DATABASE::"HR Employee Confirmation":
         BEGIN
             RecRef.SETTABLE(HrEmpConfirm);
             HrEmpConfirm.VALIDATE(Status,HrEmpConfirm.Status::Approved);
             HrEmpConfirm.MODIFY;
             Variant := HrEmpConfirm;
            END;

        */
            //HR

            //Academics ----------



            Database::"FLT-Transport Requisition":
                begin
                    RecRef.SetTable(Transport);
                    Transport.Validate(Status, Transport.Status::Approved);
                    Transport.Modify;
                    Variant := Transport;
                end;
            Database::Jobs:
                begin
                    RecRef.SetTable(Job);
                    Job.Validate(Job."Approval Status", Job."Approval Status"::Approved);
                    Job.Modify;
                    Variant := Job;
                end;
            Database::"Conference Attendance":
                begin
                    RecRef.SetTable(Conference);
                    Conference.Validate(Conference."Status", Conference."Status"::Approved);
                    Conference.Modify;
                    Variant := Conference;
                end;

            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    PurchaseHeader.Validate(PurchaseHeader."Status", PurchaseHeader."Status"::Released);
                    PurchaseHeader.Modify;
                    Variant := PurchaseHeader;
                    Handled := true;
                end;
            Database::"Vendor User Buffer":
                begin
                    RecRef.SetTable(VendorBuffer);
                    VendorBuffer.Validate(VendorBuffer."Status", VendorBuffer."Status"::Approved);
                    VendorBuffer.Modify;
                    Variant := VendorBuffer;
                end;
            Database::"Transfer Header":
                begin
                    RecRef.SetTable(TransHeader);
                    TransHeader.Validate(TransHeader."Approval Status", TransHeader."Approval Status"::Approved);
                    TransHeader.Status := TransHeader.Status::Released;
                    TransHeader.Modify;
                    Variant := TransHeader;
                    Handled := true;
                end;
            Database::"Purchase Quote Header":
                begin
                    RecRef.SetTable(RFQ);
                    RFQ.Validate(RFQ.Status, RFQ.Status::Approved);
                    RFQ.Status := RFQ.Status::Released;
                    RFQ.Modify;
                    Variant := RFQ;
                    Handled := true;
                end;
            Database::"Bank Acc. Reconciliation":
                begin
                    RecRef.SetTable(BankRecon);
                    BankRecon.Validate(BankRecon.Status, BankRecon.Status::Approved);
                    BankRecon.Status := BankRecon.Status::Approved;
                    BankRecon.Modify;
                    Variant := BankRecon;
                    Handled := true;
                end;
            Database::"Imprest Memo Header":
                begin
                    RecRef.SetTable(ImpMemo);
                    ImpMemo.Validate(ImpMemo.Status, ImpMemo.Status::Approved);
                    ImpMemo.Status := ImpMemo.Status::Approved;
                    ImpMemo.Modify;
                    Variant := ImpMemo;
                    Handled := true;
                end;
            //DirectVoucherGreenCom
            Database::"Payment Header GreenCom":
                begin
                    RecRef.SetTable(DirectVoucherGreenCom);
                    DirectVoucherGreenCom.Validate(DirectVoucherGreenCom.Status, DirectVoucherGreenCom.Status::Approved);
                    DirectVoucherGreenCom.Status := DirectVoucherGreenCom.Status::Approved;
                    DirectVoucherGreenCom.Modify;
                    Variant := DirectVoucherGreenCom;
                    Handled := true;
                end;

            Database::"Disposal Plan Header":
                begin
                    RecRef.SetTable(DeptDisposal);
                    DeptDisposal.Validate(DeptDisposal.Status, DeptDisposal.Status::Approved);
                    DeptDisposal.Status := DeptDisposal.Status::Approved;
                    DeptDisposal.Modify;
                    Variant := DeptDisposal;
                    Handled := true;
                end;

            Database::"Cons.Disposal Plan":
                begin
                    RecRef.SetTable(ConsDisposal);
                    ConsDisposal.Validate(ConsDisposal.Status, ConsDisposal.Status::Approved);
                    ConsDisposal.Status := ConsDisposal.Status::Approved;
                    ConsDisposal.Modify;
                    Variant := ConsDisposal;
                    Handled := true;
                end;

            Database::"Tender Committee":
                begin
                    RecRef.SetTable(ProcCommittee);
                    ProcCommittee.Validate(ProcCommittee.Status, ProcCommittee.Status::Approved);
                    ProcCommittee.Status := ProcCommittee.Status::Approved;
                    ProcCommittee.Modify;
                    Variant := ProcCommittee;
                    Handled := true;
                end;

            // Payment Memo
            Database::"Payment Memo":
                begin
                    RecRef.SetTable(PaymentMemo);
                    PaymentMemo.Validate(PaymentMemo.Status, PaymentMemo.Status::Approved);
                    PaymentMemo.Status := PaymentMemo.Status::Approved;
                    PaymentMemo.Modify;
                    Variant := PaymentMemo;
                    Handled := true;
                end;

            else
                Handled := false;
        // Error(UnsupportedRecordTypeErr, RecRef.Caption);

        end

    end;

    procedure SetStatusToPending(RecRef: RecordRef; var Variant: Variant; IsHandled: Boolean)
    var

        PaymentsHeader: Record "Payments Header";
        StaffAdvanceHeader: Record "Staff Advance Header";
        StaffAdvanceSurrenderHeader: Record "Staff Advance Surrender Header";
        ImprestHeader: Record "Imprest Header";
        PCA: Record "prBasic pay PCA";
        ImprestSurrenderHeader: Record "Imprest Surrender Header";
        StoreRequistionHeader: Record "Store Requistion Header";
        InterBankTransfers: Record "InterBank Transfers";
        OvertimeClaimHeader: Record "Staff Claims Header";
        Vote: Record "Vote Transfer";
        HRLeaveApp: Record "HR Leave Application";
        Hrjobs: Record "HR Jobs";
        HrTraining: Record "HR Training Applications";
        HrReq: Record "HR Employee Requisitions";

        Transport: Record "FLT-Transport Requisition";
        Job: Record Jobs;
        Conference: Record "Conference Attendance";
        PurchaseHeader: Record "Purchase Header";
        VendorBuffer: Record "Vendor User Buffer";
        TransHeader: Record "Transfer Header";
        HRBackToOffice: Record "HRBack To Office Form";
        RFQ: Record "Purchase Quote Header";
        BankRecon: Record "Bank Acc. Reconciliation";
        Workplan: Record Workplan;
        WorkplanActivities: Record "Workplan Activities";
        ImpMemo: record "Imprest Memo Header";
        DirectVoucherGreenCom: Record "Payment Header GreenCom";
        DeptDisposal: Record "Disposal Plan Header";
        ConsDisposal: Record "Cons.Disposal Plan";
        ProcCommittee: Record "Tender Committee";
        PaymentMemo: Record "Payment Memo";
    begin


        case RecRef.Number of

            Database::"HR Leave Application":
                begin
                    RecRef.SetTable(HRLeaveApp);

                    HRLeaveApp.Validate(Status, HRLeaveApp.Status::"Pending Approval");
                    HRLeaveApp.Modify;
                    Variant := HRLeaveApp;
                    IsHandled := true;

                end;

            Database::"HRBack To Office Form":
                begin
                    RecRef.SetTable(HRBackToOffice);
                    HRBackToOffice.Validate(Status, HRBackToOffice.Status::"Pending Approval");
                    HRBackToOffice.Modify;
                    Variant := HRBackToOffice;
                    IsHandled := true;

                end;

            Database::"Payments Header":
                begin
                    RecRef.SetTable(PaymentsHeader);

                    PaymentsHeader.Validate(Status, PaymentsHeader.Status::"Pending Approval");
                    PaymentsHeader.Validate(Status);
                    PaymentsHeader.Modify;
                    Variant := PaymentsHeader;
                    IsHandled := true;

                end;
            /*
        Database::"Staff Claims Header":
            begin
                RecRef.SetTable(StaffClaimsHeader);
                StaffClaimsHeader.Validate(Status, StaffClaimsHeader.Status::"Pending Approval");
                StaffClaimsHeader.Modify;
                Variant := StaffClaimsHeader;
            end;
            */
            Database::"Staff Advance Header":

                begin
                    RecRef.SetTable(StaffAdvanceHeader);

                    StaffAdvanceHeader.Validate(Status, StaffAdvanceHeader.Status::"Pending Approval");
                    StaffAdvanceHeader.Modify;
                    Variant := StaffAdvanceHeader;
                    IsHandled := true;
                end;
            Database::"Staff Advance Surrender Header":
                begin
                    RecRef.SetTable(StaffAdvanceSurrenderHeader);

                    StaffAdvanceSurrenderHeader.Validate(Status, StaffAdvanceSurrenderHeader.Status::"Pending Approval");
                    StaffAdvanceSurrenderHeader.Modify;
                    Variant := StaffAdvanceSurrenderHeader;
                    IsHandled := true;
                end;
            Database::"Imprest Header":
                begin
                    RecRef.SetTable(ImprestHeader);

                    ImprestHeader.Validate(Status, ImprestHeader.Status::"Pending Approval");
                    ImprestHeader.Validate(Status);
                    ImprestHeader.Modify;
                    Variant := ImprestHeader;
                    IsHandled := true;
                end;
            Database::"prBasic pay PCA":
                begin
                    RecRef.SetTable(PCA);

                    PCA.Validate(Status, PCA.Status::"Pending Approval");
                    PCA.Validate(Status);
                    PCA.Modify;
                    Variant := PCA;
                    IsHandled := true;
                end;
            Database::"Imprest Surrender Header":
                begin
                    RecRef.SetTable(ImprestSurrenderHeader);

                    ImprestSurrenderHeader.Validate(Status, ImprestSurrenderHeader.Status::"Pending Approval");
                    ImprestSurrenderHeader.Validate(Status);
                    ImprestSurrenderHeader.Modify;
                    Variant := ImprestSurrenderHeader;
                    IsHandled := true;
                end;
            //new store
            Database::"Store Requistion Header":
                begin
                    RecRef.SetTable(StoreRequistionHeader);
                    StoreRequistionHeader.Validate(Status, StoreRequistionHeader.Status::"Pending Approval");
                    StoreRequistionHeader.Modify;
                    Variant := StoreRequistionHeader;
                    IsHandled := true;
                end;

            Database::"InterBank Transfers":
                begin
                    RecRef.SetTable(InterBankTransfers);

                    InterBankTransfers.Validate(Status, InterBankTransfers.Status::"Pending Approval");
                    InterBankTransfers.Modify;
                    Variant := InterBankTransfers;
                    IsHandled := true;
                end;
            Database::"Staff Claims Header":
                begin
                    RecRef.SetTable(OvertimeClaimHeader);

                    OvertimeClaimHeader.Validate(Status, OvertimeClaimHeader.Status::"Pending Approval");
                    OvertimeClaimHeader.Validate(Status);
                    OvertimeClaimHeader.Modify;
                    Variant := OvertimeClaimHeader;
                    IsHandled := true;
                end;
            /*
              DATABASE::"G/L Budget Name":
                BEGIN
                 RecRef.SETTABLE(Budget);
                 Budget.VALIDATE(Status,Budget.Status::"1");
                 Budget.MODIFY;
                 Variant := Budget;
                END;
                
            */
            DATABASE::Workplan:
                BEGIN
                    RecRef.SETTABLE(Workplan);
                    Workplan.VALIDATE(Status, Workplan.Status::"Pending Approval");
                    Workplan.MODIFY;
                    Variant := Workplan;
                    IsHandled := true;
                END;
            DATABASE::"Workplan Activities":
                BEGIN
                    RecRef.SETTABLE(WorkplanActivities);
                    WorkplanActivities.VALIDATE(Status, WorkplanActivities.Status::"Pending Approval");
                    WorkplanActivities.MODIFY;
                    Variant := WorkplanActivities;
                    IsHandled := true;
                END;

            Database::"Vote Transfer":
                begin
                    RecRef.SetTable(Vote);
                    Vote.Validate(Status, Vote.Status::"Pending Approval");
                    Vote.Modify;
                    Variant := Vote;
                    IsHandled := true;
                end;
            /*
            //Investiment
              DATABASE::"Bank Account":
               BEGIN
               RecRef.SETTABLE(Invest);
              Invest.VALIDATE(Status,Invest.Status::"Pending Approval");
              Invest.MODIFY;
              Variant:=Invest;
              END;
            //HR
            */
            // Database::"HR Leave Application":
            //     begin
            //         RecRef.SetTable(Hrleave);
            //         Hrleave.Validate(Status, Hrleave.Status::"Pending Approval");
            //         Hrleave.Modify;
            //         Variant := Hrleave;
            //         IsHandled := true;
            //     end;

            Database::"HR Jobs":
                begin
                    RecRef.SetTable(Hrjobs);
                    Hrjobs.Validate(Status, Hrjobs.Status::"Pending Approval");
                    Hrjobs.Modify;
                    Variant := Hrjobs;
                    IsHandled := true;
                end;

            Database::"HR Employee Requisitions":
                begin
                    RecRef.SetTable(HrReq);
                    HrReq.Validate(Status, HrReq.Status::"Pending Approval");
                    HrReq.Modify;
                    Variant := HrReq;
                    IsHandled := true;
                end;

            DATABASE::"HR Training Applications":
                BEGIN
                    RecRef.SETTABLE(HrTraining);
                    HrTraining.VALIDATE(Status, HrTraining.Status::"Pending Approval");
                    HrTraining.MODIFY;
                    Variant := HrTraining;
                END;

            /*

                      DATABASE::"HR Employee Transfer Header":
                          BEGIN
                           RecRef.SETTABLE( HrEmpTrans);
                           HrEmpTrans.VALIDATE(Status,HrEmpTrans.Status::"Pending Approval");
                           HrEmpTrans.MODIFY;
                           Variant := HrEmpTrans;
                          END;

                      DATABASE::"HR Employee Transfer Header":
                          BEGIN
                           RecRef.SETTABLE( HrEmpTrans);
                           HrEmpTrans.VALIDATE(Status,HrEmpTrans.Status::"Pending Approval");
                           HrEmpTrans.MODIFY;
                           Variant := HrEmpTrans;
                          END;

                      DATABASE::"HR Promo. Recommend Header":
                      BEGIN
                           RecRef.SETTABLE( HrPromo);
                           HrPromo.VALIDATE(Status,HrPromo.Status::"Pending Approval");
                           HrPromo.MODIFY;
                           Variant := HrPromo;
                          END;

                       DATABASE::"HR Transport Requisition":
                       BEGIN
                           RecRef.SETTABLE(HrTransport);
                           HrTransport.VALIDATE(Status,HrTransport.Status::"Pending Approval");
                           HrTransport.MODIFY;
                           Variant := HrTransport;
                          END;

                      DATABASE::"HR Asset Transfer Header":
                      BEGIN
                           RecRef.SETTABLE(HrAssetTrans);
                           HrAssetTrans.VALIDATE(Status,HrAssetTrans.Status::"Pending Approval");
                           HrAssetTrans.MODIFY;
                           Variant := HrAssetTrans;
                          END;

                      DATABASE::"HR Employee Confirmation":
                      BEGIN
                           RecRef.SETTABLE(HrEmpConfirm);
                           HrEmpConfirm.VALIDATE(Status,HrEmpConfirm.Status::"Pending Approval");
                           HrEmpConfirm.MODIFY;
                           Variant := HrEmpConfirm;
                          END;
                        */
            //HR
            //Academics


            //Academics


            Database::"FLT-Transport Requisition":
                begin
                    RecRef.SetTable(Transport);

                    Transport.Validate(Status, Transport.Status::"Pending Approval");
                    Transport.Modify;
                    Variant := Transport;
                    IsHandled := true;
                end;
            Database::Jobs:
                begin
                    RecRef.SetTable(Job);
                    Job.Validate(Job."Approval Status", Job."Approval Status"::"Pending Approval");
                    Job.Modify;
                    Variant := Job;
                    IsHandled := true;
                end;
            Database::"Conference Attendance":
                begin
                    RecRef.SetTable(Conference);
                    Conference.Validate(Conference."Status", Conference."Status"::"Pending Approval");
                    Conference.Modify;
                    Variant := Job;
                    IsHandled := true;
                end;
            //HR Leave Application
            DATABASE::"HR Leave Application":
                BEGIN
                    RecRef.SetTable(HRLeaveApp);

                    HRLeaveApp.Validate(Status, HRLeaveApp.Status::"Pending Approval");
                    HRLeaveApp.Validate(Status);
                    HRLeaveApp.Modify;
                    Variant := HRLeaveApp;
                    IsHandled := true;
                END;
            //Purchase Requisition
            Database::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);

                    PurchaseHeader.Validate(Status, PurchaseHeader.Status::"Pending Approval");

                    PurchaseHeader.Validate(Status);
                    PurchaseHeader.Modify;
                    Variant := PurchaseHeader;
                    IsHandled := true;
                end;


            //Vendor Prequalification
            DATABASE::"Vendor User Buffer":
                BEGIN
                    RecRef.SETTABLE(VendorBuffer);

                    VendorBuffer.VALIDATE(Status, VendorBuffer.Status::"Pending Approval");
                    VendorBuffer.MODIFY;
                    Variant := VendorBuffer;
                END;
            DATABASE::"Transfer Header":
                BEGIN
                    RecRef.SETTABLE(TransHeader);

                    TransHeader.VALIDATE("Approval Status", TransHeader."Approval Status"::"Pending Approval");
                    TransHeader.MODIFY;
                    Variant := TransHeader;
                END;

            DATABASE::"Purchase Quote Header":
                BEGIN
                    RecRef.SETTABLE(RFQ);

                    RFQ.VALIDATE(Status, RFQ.Status::"Pending Approval");
                    RFQ.MODIFY;
                    Variant := TransHeader;
                END;
            DATABASE::"Bank Acc. Reconciliation":
                BEGIN
                    RecRef.SETTABLE(BankRecon);

                    BankRecon.VALIDATE(Status, BankRecon.Status::"Pending Approval");
                    BankRecon.MODIFY;
                    Variant := BankRecon;
                END;
            DATABASE::"Imprest Memo Header":
                BEGIN
                    RecRef.SETTABLE(ImpMemo);

                    ImpMemo.VALIDATE(Status, ImpMemo.Status::"Pending Approval");
                    ImpMemo.MODIFY;
                    Variant := ImpMemo;
                END;
            //DirectVoucherGreenCom
            DATABASE::"Payment Header GreenCom":
                BEGIN
                    RecRef.SETTABLE(DirectVoucherGreenCom);

                    DirectVoucherGreenCom.VALIDATE(Status, DirectVoucherGreenCom.Status::"Pending Approval");
                    DirectVoucherGreenCom.MODIFY;
                    Variant := DirectVoucherGreenCom;
                END;
            DATABASE::"Disposal Plan Header":
                BEGIN
                    RecRef.SETTABLE(DeptDisposal);

                    DeptDisposal.VALIDATE(DeptDisposal.Status, DeptDisposal.Status::"Pending Approval");
                    DeptDisposal.MODIFY;
                    Variant := DeptDisposal;
                END;
            DATABASE::"Cons.Disposal Plan":
                BEGIN
                    RecRef.SETTABLE(ConsDisposal);

                    ConsDisposal.VALIDATE(Status, ConsDisposal.Status::"Pending Approval");
                    ConsDisposal.MODIFY;
                    Variant := ConsDisposal;
                END;
            DATABASE::"Tender Committee":
                BEGIN
                    RecRef.SETTABLE(ProcCommittee);

                    ProcCommittee.VALIDATE(Status, ProcCommittee.Status::"Pending Approval");
                    ProcCommittee.MODIFY;
                    Variant := ProcCommittee;
                END;

            Database::"Payment Memo":
                begin
                    RecRef.SETTABLE(PaymentMemo);

                    PaymentMemo.VALIDATE(Status, PaymentMemo.Status::"Pending Approval");
                    PaymentMemo.MODIFY;
                    Variant := PaymentMemo;
                end;


            else
                Error(UnsupportedRecordTypeErr, RecRef.Caption);

        end;

    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDocForApproval(var Variant: Variant)
    begin
    end;


}

