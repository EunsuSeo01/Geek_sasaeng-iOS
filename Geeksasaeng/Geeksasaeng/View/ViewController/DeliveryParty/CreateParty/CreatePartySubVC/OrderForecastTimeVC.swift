//
//  OrderForecastTimeVC.swift
//  Geeksasaeng
//
//  Created by 조동진 on 2022/07/12.
//

import UIKit
import SnapKit
import Then

class OrderForecastTimeViewController: UIViewController {
    
    // MARK: - Properties
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // MARK: - SubViews
    /* titleLabel: 주문 예정 시간 */
    let titleLabel = UILabel().then {
        $0.text = "주문 예정 시간"
        $0.font = .customFont(.neoMedium, size: 18)
    }
    
    /* dateTextField: 현재 날짜 */
    let dateTextField = UITextField().then {
        let formatter = DateFormatter().then {
            $0.dateFormat = "MM월 dd일"
            $0.locale = Locale(identifier: "ko_KR")
        }
        $0.text = formatter.string(from: Date())
        $0.font = .customFont(.neoMedium, size: 32)
        $0.tintColor = .clear
        $0.textColor = .black
    }
    
    /* tileLabel: 현재 시간 */
    let timeTextField = UITextField().then {
        let formatter = DateFormatter().then {
            $0.dateFormat = "HH시 mm분"
            $0.locale = Locale(identifier: "ko_KR")
        }
        $0.text = formatter.string(from: Date())
        $0.font = .customFont(.neoMedium, size: 20)
        $0.tintColor = .clear
        $0.textColor = .black
    }
    
    /* nextButton: 다음 버튼 */
    lazy var nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(UIColor(hex: 0xA8A8A8), for: .normal)
        $0.titleLabel?.font = .customFont(.neoBold, size: 20)
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(hex: 0xEFEFEF)
        $0.clipsToBounds = true
        $0.setActivatedNextButton()
        $0.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
    }
    
    /* pageLabel: 1/5 */
    let pageLabel = UILabel().then {
        $0.text = "1/5"
        $0.font = .customFont(.neoMedium, size: 13)
        $0.textColor = UIColor(hex: 0xD8D8D8)
    }
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setViewLayout()
        addSubViews()
        setLayouts()
        setDatePicker()
        setTimePicker()
        setDefaultValueOfPicker()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Functions
    private func setViewLayout() {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 7
        view.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.29)
            make.height.equalTo(screenHeight / 2.1)
        }
    }
    
    private func setDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Calendar.current.startOfDay(for: Date())
        datePicker.maximumDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())
        datePicker.addTarget(self, action: #selector(changedDatePickerValue), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ko_KR")
        dateTextField.inputView = datePicker
        
        /* 최대 날짜 설정 (7일 후까지) */
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date()
        var components = DateComponents()
    
        components.calendar = calendar
        components.day = 7
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = currentDate
        datePicker.maximumDate = maxDate
    }
    
    private func setTimePicker() {
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(changedTimePickerValue), for: .valueChanged)
        timePicker.locale = Locale(identifier: "ko_KR")
        timeTextField.inputView = timePicker
    }
    
    private func addSubViews() {
        [titleLabel, dateTextField, timeTextField, nextButton, pageLabel].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayouts() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(screenHeight / 29.37)
            make.centerX.equalToSuperview()
        }
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(screenHeight / 9.06)
            make.centerX.equalToSuperview()
        }
        
        timeTextField.snp.makeConstraints { make in
            make.top.equalTo(dateTextField.snp.bottom).offset(screenHeight / 50.11)
            make.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalTo(screenWidth / 1.5)
            make.height.equalTo(screenHeight / 16.7)
            make.bottom.equalToSuperview().inset(screenHeight / 24.34)
            make.centerX.equalToSuperview()
        }
        
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(screenHeight / 85.2)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setDefaultValueOfPicker() {
        if let orderForecastTime = CreateParty.orderForecastTime {
            let str = orderForecastTime.replacingOccurrences(of: " ", with: "")
            let startIdx = str.index(str.startIndex, offsetBy: 6)
            let dateRange = ..<startIdx // 월, 일
            let timeRange = startIdx... // 시, 분
            // TextField 초기값 설정
            dateTextField.text = "\(str[dateRange])"
            timeTextField.text = "\(str[timeRange])"
            
            // PickerView 초기값 설정
            let dateStr = str[dateRange].replacingOccurrences(of: "월", with: "-").replacingOccurrences(of: "일", with: "")
            let timeStr = str[timeRange].replacingOccurrences(of: "시", with: ":").replacingOccurrences(of: "분", with: "")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            let currentYears = formatter.string(from: Date())
            // 최종 문자열
            let formattedDate = "\(currentYears)-\(dateStr)"
            let formattedTime = "\(timeStr)"
            formatter.dateFormat = "yyyy-MM-dd"
            if let formattedDate = formatter.date(from: formattedDate) {
                datePicker.setDate(formattedDate, animated: true)
            }
            formatter.dateFormat = "HH:mm"
            if let formattedTime = formatter.date(from: formattedTime) {
                timePicker.setDate(formattedTime, animated: true)
            }
        }
    }
    
    /* 떠있던 pickerView를 아래로 내린다. */
    private func goDownPicker() {
        self.dateTextField.resignFirstResponder()
        self.timeTextField.resignFirstResponder()
    }
    
    // MARK: - @objc Functions
    
    @objc
    private func changedDatePickerValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        
        dateTextField.text = formatter.string(from: datePicker.date)
        dateTextField.sendActions(for: .editingChanged)
    }
    
    @objc
    private func changedTimePickerValue() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        
        timeTextField.text = formatter.string(from: timePicker.date)
        timeTextField.sendActions(for: .editingChanged)
    }
    
    @objc
    private func tapNextButton() {
        // 날짜, 시간 정보 전역변수에 저장
        CreateParty.orderForecastTime = "\(dateTextField.text!)        \(timeTextField.text!)"
        
        // API Input에 저장
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: datePicker.date)
        formatter.dateFormat = "HH:mm:ss"
        let time = formatter.string(from: timePicker.date)
        CreateParty.orderTime = "\(date) \(time)"
        
        // pickerview 내리기
        goDownPicker()
        
        // addSubview animation 처리
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            let childView = MatchingPersonViewController()
            self.addChild(childView)
            self.view.addSubview(childView.view)
            childView.view.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }, completion: nil)
    }
}
