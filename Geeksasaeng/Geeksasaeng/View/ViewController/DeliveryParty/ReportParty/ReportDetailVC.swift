//
//  ReportDetailVC.swift
//  Geeksasaeng
//
//  Created by 서은수 on 2022/07/21.
//

import UIKit

import SnapKit
import Then

class ReportDetailViewController: UIViewController {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 유저 차단 체크박스가 체크되었는지 확인하기 위해
    var isBlock: Bool = false
    
    // 신고할 때 필요한 id값들
    var reportCategoryId: Int?
    var partyId: Int?
    var memberId: Int?
    
    // MARK: - SubViews
    
    let reportCategoryLabel = UILabel().then {
        $0.setTextAndColorAndFont(textColor: .black, font: .customFont(.neoMedium, size: 16))
    }
    
    let textViewPlaceHolder = "(선택) 어떤 상황인가요? 긱사생에게 알려주시면 문제 해결에 도움이 될 수 있어요."
    lazy var reportTextView = UITextView().then {
        $0.backgroundColor = .white
        $0.text = textViewPlaceHolder
        $0.textColor = .init(hex: 0xD8D8D8)
        $0.font = .customFont(.neoRegular, size: 15)
        $0.autocorrectionType = .no
        $0.autocapitalizationType = .none
    }
    
    let separateView = UIView().then {
        $0.backgroundColor = .init(hex: 0xF8F8F8)
    }
    
    lazy var checkBoxButton = UIButton().then {
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.addTarget(self, action: #selector(tapCheckBoxButton(_:)), for: .touchUpInside)
        $0.tintColor = .init(hex: 0x5B5B5B)
    }
    
    let blockUserLabel = UILabel().then {
        $0.setTextAndColorAndFont(text: "이 사용자 차단하기", textColor: .mainColor, font: .customFont(.neoMedium, size: 15))
    }
    
    let guideLabel = UILabel().then {
        $0.setTextAndColorAndFont(text: "[프로필] >  [설정] > [사용자 관리]에서 취소할 수 있어요.",
                                     textColor: .init(hex: 0xA8A8A8),
                                     font: .customFont(.neoRegular, size: 15))
        $0.numberOfLines = 0
    }
    
    // 하단에 있는 신고하기 버튼
    lazy var reportButton = UIButton().then {
        $0.backgroundColor = .mainColor
        $0.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        
        let reportLabel = UILabel().then {
            $0.setTextAndColorAndFont(text: "신고하기", textColor: .white, font: .customFont(.neoBold, size: 20))
        }
        $0.addSubview(reportLabel)
        reportLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // 배경에 뜰 어두운 블러뷰
    var visualEffectView: UIVisualEffectView?
    
    /* 신고하기 성공 시 나오는 신고성공 안내 뷰 */
    lazy var reportSuccessView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        $0.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.4)
            make.height.equalTo(screenHeight / 3.94)
        }
        
        /* top View */
        let topSubView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xF8F8F8)
        }
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 16)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.setTextAndColorAndFont(text: "신고하기", textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 14))
        }
        topSubView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.removeView(sender:)), for: .touchUpInside)
        }
        topSubView.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(screenWidth / 18)
            make.height.equalTo(screenHeight / 66.66)
            make.right.equalToSuperview().offset(-(screenWidth / 24))
        }
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView().then {
            $0.backgroundColor = .white
        }
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 5.22)
        }
        
        let contentLabel = UILabel().then {
            /* set contentLabel */
            $0.setTextAndColorAndFont(
                text: "요청하신 사항에 따른 신고가\n정상적으로 처리되었어요.",
                textColor: .init(hex: 0x2F2F2F), font: .customFont(.neoMedium, size: 14))
            $0.numberOfLines = 0
            let attrString = NSMutableAttributedString(string: $0.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 6
            paragraphStyle.alignment = .center
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            $0.attributedText = attrString
        }
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            /* set confirmButton */
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.removeView(sender:)), for: .touchUpInside)
        }
        
        [contentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(screenHeight / 38.09)
        }
        /* set lineView */
        lineView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(screenHeight / 53.33)
            make.left.equalTo(screenWidth / 20)
            make.right.equalTo(-(screenWidth / 20))
            make.height.equalTo(screenHeight / 470.58)
        }
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(screenHeight / 44.44)
            make.width.height.equalTo(screenWidth / 10.58)
        }
    }
    
    /* 신고실패 안내뷰의 contents label */
    let failContentLabel = UILabel().then {
        /* set failContentLabel */
        $0.numberOfLines = 0
        $0.setTextAndColorAndFont(textColor: .init(hex: 0x2F2F2F), font: .customFont(.neoMedium, size: 14))
    }
    
    /* 신고하기 실패 시 나오는 신고실패 안내 뷰 */
    lazy var reportFailView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
        $0.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.4)
            make.height.equalTo(screenHeight / 3.94)
        }
        
        /* top View */
        let topSubView = UIView()
        topSubView.backgroundColor = UIColor(hex: 0xF8F8F8)
        $0.addSubview(topSubView)
        topSubView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(screenHeight / 16)
        }
        
        /* set titleLabel */
        let titleLabel = UILabel().then {
            $0.setTextAndColorAndFont(text: "신고하기", textColor: .init(hex: 0xA8A8A8), font: .customFont(.neoMedium, size: 14))
            topSubView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
        
        /* set cancelButton */
        lazy var cancelButton = UIButton().then {
            $0.setImage(UIImage(named: "Xmark"), for: .normal)
            $0.addTarget(self, action: #selector(self.removeView(sender:)), for: .touchUpInside)
            topSubView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(self.screenWidth / 18)
                make.height.equalTo(self.screenHeight / 66.66)
                make.right.equalToSuperview().offset(-(self.screenWidth / 24))
            }
        }
        
        
        /* bottom View: contents, 확인 버튼 */
        let bottomSubView = UIView()
        bottomSubView.backgroundColor = .white
        $0.addSubview(bottomSubView)
        bottomSubView.snp.makeConstraints { make in
            make.top.equalTo(topSubView.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 5.22)
        }
        
        let lineView = UIView().then {
            $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        }
        lazy var confirmButton = UIButton().then {
            $0.setTitleColor(.mainColor, for: .normal)
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .customFont(.neoBold, size: 18)
            $0.addTarget(self, action: #selector(self.removeView(sender:)), for: .touchUpInside)
        }
        
        [failContentLabel, lineView, confirmButton].forEach {
            bottomSubView.addSubview($0)
        }
        
        /* set failContentLabel */
        let attrString = NSMutableAttributedString(string: failContentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        failContentLabel.attributedText = attrString
        
        failContentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(screenHeight / 40)
            make.width.equalTo(screenWidth / 1.89)
            make.height.equalTo(screenHeight / 16.66)
        }
        
        /* set lineView */
        lineView.snp.makeConstraints { make in
            make.top.equalTo(failContentLabel.snp.bottom).offset(15)
            make.left.equalTo(screenWidth / 20)
            make.right.equalTo(-(screenWidth / 20))
            make.height.equalTo(screenHeight / 470.58)
        }
        
        /* set confirmButton */
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(screenHeight / 44.44)
            make.width.height.equalTo(screenWidth / 10.58)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setAttributes()
        addSubViews()
        setLayouts()
        
        reportTextView.delegate = self
        // view에 탭 제스쳐 추가 -> 키보드 숨기려고
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
                view.addGestureRecognizer(tapGesture)
        
        print("DEBUG: 어떤 사유로 사용자 신고 화면 데이터", reportCategoryLabel.text, reportCategoryId, partyId, memberId)
    }
    
    /* 뷰 생길 때 옵져버를 등록 */
    override func viewWillAppear(_ animated: Bool) {
        // selector: 옵져버 감지 시 실행할 함수
        // name: 옵져버가 감지할 것 -> 키보드가 나타나는지/숨겨지는지
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /* 뷰 사라질 때, 반드시 옵져버를 리무브 할 것! */
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 뷰가 어떤 이유에서든지 사라지면 tabBar를 다시 보이게 한다
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Initialization
    
    init(labelText: String, reportCategoryId: Int?, partyId: Int?, memberId: Int?) {
        super.init(nibName: nil, bundle: nil)
        self.reportCategoryLabel.text = labelText
        self.reportCategoryId = reportCategoryId
        self.partyId = partyId
        self.memberId = memberId
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    private func setAttributes() {
        // 하단 탭바 숨기기
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
        /* Navigation Bar Attrs */
        self.navigationItem.title = "신고하기"
        navigationItem.hidesBackButton = true   // 원래 백버튼은 숨기고,
        
        // 커스텀한 새 백버튼으로 구성
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back"), style: .plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func addSubViews() {
        [
            reportCategoryLabel,
            reportTextView,
            separateView,
            checkBoxButton,
            blockUserLabel,
            guideLabel,
            reportButton
        ].forEach { view.addSubview($0) }
    }
    
    private func setLayouts() {
        reportCategoryLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(screenHeight / 26.66)
            make.left.equalToSuperview().inset(screenWidth / 12.41)
        }
        reportTextView.snp.makeConstraints { make in
            make.top.equalTo(reportCategoryLabel.snp.bottom).offset(screenHeight / 34.78)
            make.left.right.equalToSuperview().inset(screenWidth / 12.41)
            make.height.equalTo(screenHeight / 8)
        }
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(reportTextView.snp.bottom).offset(screenHeight / 40)
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 100)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom).offset(screenHeight / 32)
            make.left.equalToSuperview().inset(screenWidth / 12.41)
        }
        blockUserLabel.snp.makeConstraints { make in
            make.left.equalTo(checkBoxButton.snp.right).offset(screenWidth / 72)
            make.centerY.equalTo(checkBoxButton)
        }
        guideLabel.snp.makeConstraints { make in
            make.top.equalTo(blockUserLabel.snp.bottom).offset(screenHeight / 72.72)
            make.left.right.equalToSuperview().inset(screenWidth / 12)
        }
        
        reportButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(screenHeight / 10.66)    // 20은 safeAreaLayoutGuide 아래 빈 공간 가리기 위해 추가
            make.bottom.equalToSuperview()
        }
    }
    
    /* 신고하기 완료 안내 뷰 보여주는 함수 */
    private func showReportSuccessView() {
        view.addSubview(reportSuccessView)
        reportSuccessView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    /* 신고하기 실패 안내 뷰 보여주는 함수 */
    private func showReportFailView(_ message: String) {
        failContentLabel.text = message
        
        view.addSubview(reportFailView)
        reportFailView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    // MARK: - @objc Functions

    /* 키보드 숨기기 */
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    /* 이 사용자 차단하기 체크 박스 누르면 체크 모양 뜨도록 */
    @objc
    private func tapCheckBoxButton(_ sender: UIButton) {
        isBlock = !isBlock
        (isBlock) ? sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal) : sender.setImage(UIImage(systemName: "square"), for: .normal)
    }
    
    /* 키보드 올라올 때 실행되는 함수 */
    @objc
    private func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            // reportBarView의 y축을 키보드 높이만큼 올려준다
            UIView.animate(
                withDuration: 0.3, animations: {
                    self.reportButton.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 20)
                }
            )
        }
    }
    
    /* 키보드 내려갈 때 실행되는 함수 */
    @objc
    private func keyboardDown() {
        // reportBarView 위치 제자리로
        self.reportButton.transform = .identity
    }
    
    /* 하단의 신고하기 버튼을 눌렀을 때 실행되는 함수 -> 신고 제출, 신고하기 성패 안내 */
    @objc
    private func tapReportButton() {
        MyLoadingView.shared.show()
        
        guard let reportCategoryId = reportCategoryId else { return }
        
        print("reportCategoryId: ", reportCategoryId)
        // 파티 게시글 신고일 때
        if reportCategoryId < 5 {
            let input = ReportPartyInput(block: isBlock, reportCategoryId: self.reportCategoryId, reportContent: reportTextView.text, reportedDeliveryPartyId: partyId, reportedMemberId: memberId)
            ReportAPI.requestReportParty(input) { isSuccess, resultMessage in
                MyLoadingView.shared.hide()
                
                // 블러뷰 세팅
                self.visualEffectView = self.setDarkBlurView()
                
                if isSuccess {
                    // 성공했으면 성공안내 뷰 띄워주기
                    self.showReportSuccessView()
                } else {
                    // 성공했으면 실패안내 뷰 띄워주기
                    guard let resultMessage = resultMessage else { return }
                    self.showReportFailView(resultMessage)
                }
            }
        } else {    // 사용자 신고일 때
            let input = ReportMemberInput(block: isBlock, reportCategoryId: self.reportCategoryId, reportContent: reportTextView.text, reportedMemberId: memberId)
            ReportAPI.requestReportMember(input) { isSuccess, resultMessage in
                MyLoadingView.shared.hide()
                
                // 블러뷰 세팅
                self.visualEffectView = self.setDarkBlurView()
                
                if isSuccess {
                    // 성공했으면 성공안내 뷰 띄워주기
                    self.showReportSuccessView()
                } else {
                    // 성공했으면 실패안내 뷰 띄워주기
                    guard let resultMessage = resultMessage else { return }
                    self.showReportFailView(resultMessage)
                }
            }
        }
    }
    
    /* 신고하기 완료/실패 안내 뷰에서 X버튼이나 확인버튼을 눌렀을 때 실행되는 함수 */
    @objc
    private func removeView(sender: UIButton) {
        guard let view = sender.superview else { return }
        view.removeFromSuperview()
        visualEffectView?.removeFromSuperview()
        
        // 안내뷰랑 블러뷰 제거하고 이전 화면으로 이동
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension ReportDetailViewController: UITextViewDelegate {
    
    /* 텍스트뷰에 입력을 시작 할 때 실행 */
    func textViewDidBeginEditing(_ textView: UITextView) {
        // 첫 입력이면 placeholder 지워주고 시작
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .init(hex: 0x5B5B5B)
        }
    }
    
    /* 텍스트뷰에 입력을 끝낼 때 실행 */
    func textViewDidEndEditing(_ textView: UITextView) {
        // 작성 끝났는데 내용이 없으면 placeholder 다시 만들어줌
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .init(hex: 0xD8D8D8)
        }
    }
    
    /* 텍스트뷰에 내용이 바뀔 때마다 실행, 최대 몇 글자까지 가능한지 적어두면 됨 */
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        // 공백 제외 최대 100글자
        guard characterCount <= 100 else { return false }

        return true
    }
}
