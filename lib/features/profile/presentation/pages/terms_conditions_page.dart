import 'package:flutter/material.dart';
import 'package:ftes/core/utils/text_styles.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F9FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF202244),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Điều Khoản Dịch Vụ',
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildImportantNotice(),
            const SizedBox(height: 20),
            _buildConcepts(),
            const SizedBox(height: 20),
            _buildServices(),
            const SizedBox(height: 20),
            _buildRightsAndResponsibilities(),
            const SizedBox(height: 20),
            _buildAccountSecurity(),
            const SizedBox(height: 20),
            _buildPricing(),
            const SizedBox(height: 20),
            _buildDisclaimer(),
            const SizedBox(height: 20),
            _buildComplaints(),
            const SizedBox(height: 20),
            _buildEffectiveness(),
            const SizedBox(height: 20),
            _buildContact(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI-Learning FTES - Điều khoản và điều kiện sử dụng dịch vụ',
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Công ty TNHH Giải pháp giáo dục FTES',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF0961F5),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Cập nhật: 2025',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildImportantNotice() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFFC107)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFFC107),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Thông báo quan trọng',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF856404),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Vui lòng đọc kỹ các điều khoản này trước khi sử dụng dịch vụ AI-Learning của FTES. Việc sử dụng dịch vụ đồng nghĩa với việc bạn đồng ý với tất cả các điều khoản được nêu dưới đây.',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF856404),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConcepts() {
    return _buildSection(
      title: 'Các khái niệm',
      children: [
        _buildConceptItem(
          'Công ty TNHH Giải pháp giáo dục FTES',
          'Công ty TNHH Giải pháp Công nghệ Giáo dục FTES (sau đây gọi tắt là FTES).',
        ),
        _buildConceptItem(
          'Dịch vụ AI-Learning',
          'Là bất kỳ dịch vụ nào liên quan đến các khóa học và những tính năng AI kèm theo được cung cấp bởi FTES.',
        ),
        _buildConceptItem(
          'Lộ trình học',
          'Là một chuỗi các khóa học được xây dựng và sắp xếp bảo đảm theo đúng nhu cầu và điều kiện của học viên hiện tại.',
        ),
        _buildConceptItem(
          'Khóa học',
          'Là lĩnh vực học, bao gồm toàn bộ các bài học liên quan tới lĩnh vực đề cập trong khóa học.\nVí dụ: Khóa học "Web design for everyone" dành cho những học viên học về thiết kế web.',
        ),
        _buildConceptItem(
          'Bài học',
          'Là đơn vị nhỏ nhất sau khóa học, thể hiện nội dung cụ thể bằng video/tài liệu/kiểm tra/thực hành… liên quan tới chủ đề của khóa học.\nVí dụ: Khóa học "Web design for everyone" bao gồm "Khái niệm cơ bản", "Một số công cụ lập trình cho thiết kế web", "Bài kiểm tra số 1", "Thực hành cuối khóa"…',
        ),
        _buildConceptItem(
          'Học viên',
          'Đề cập đến bất kỳ cá nhân nào sử dụng bất kỳ khía cạnh nào của trang web và/hoặc các Dịch vụ AI-Learning.',
        ),
        _buildConceptItem(
          'Chatbot',
          'Trợ lý AI 24/7 giúp hỗ trợ, giải đáp các nội dung có trong bài học hoặc trang hiện tại đang truy cập.',
        ),
      ],
    );
  }

  Widget _buildServices() {
    return _buildSection(
      title: 'Dịch vụ và thông tin truyền thông của FTES',
      children: [
        _buildSubSection(
          'ftes.vn',
          [
            'Là trang web chính thức và duy nhất cung cấp các khóa học AI-Learning và các thông tin truyền thông khác do FTES sở hữu và quản lý. Mọi trang web khác có nội dung liên quan như trên đều không chính thức và không thuộc quyền sở hữu của FTES.',
            'Trang web ftes.vn có thể bao gồm văn bản, đồ họa, liên kết, hình ảnh, âm thanh, video, phần mềm, cùng các nội dung và dữ liệu khác (gọi chung là "nội dung, thông tin"). Các nội dung này được định dạng, tổ chức và thu thập dưới nhiều hình thức khác nhau, mà Người dùng có thể đăng ký truy cập hoặc mua.',
          ],
        ),
      ],
    );
  }

  Widget _buildRightsAndResponsibilities() {
    return _buildSection(
      title: 'Quyền lợi và trách nhiệm của học viên',
      children: [
        _buildSubSection(
          'Quyền lợi',
          [
            'Được truy cập và sử dụng các khóa học AI-Learning, lộ trình học, bài học và các nội dung khác đã thực hiện thanh toán thành công theo đúng thông tin tài khoản đã đăng ký.',
            'Được tiếp cận nội dung bài học dưới nhiều hình thức (video, tài liệu, bài kiểm tra, thực hành…) theo phạm vi khóa học đã mua hoặc được cấp quyền.',
            'Được hỗ trợ bởi Chatbot 24/7 trong việc giải đáp nội dung có trong bài học hoặc trên trang đang truy cập.',
            'Được nhận các thông báo, email và hình thức truyền thông khác từ FTES về sản phẩm, dịch vụ và các ưu đãi liên quan.',
            'Được đảm bảo quyền riêng tư, bảo mật thông tin cá nhân và giải quyết khiếu nại theo chính sách bảo mật, khiếu nại của FTES.',
          ],
        ),
        _buildSubSection(
          'Trách nhiệm',
          [
            'Cung cấp thông tin đăng ký tài khoản đầy đủ, chính xác và luôn cập nhật; đồng thời chịu trách nhiệm về tính xác thực của những thông tin đã cung cấp.',
            'Tuân thủ đầy đủ các điều khoản, quy định và hướng dẫn sử dụng dịch vụ AI-Learning của FTES.',
            'Sử dụng duy nhất email đã đăng ký trong toàn bộ quá trình học; chỉ thay đổi email khi có sự chấp thuận đặc biệt từ FTES.',
            'Thực hiện thanh toán đầy đủ chi phí khóa học theo mức giá và phương thức được công bố; đồng thời chịu các khoản phí phát sinh trong quá trình thanh toán (nếu có).',
            'Bảo mật thông tin cá nhân và không sử dụng nội dung khóa học vào các mục đích vi phạm bản quyền hoặc gây ảnh hưởng đến uy tín của FTES.',
          ],
        ),
      ],
    );
  }

  Widget _buildAccountSecurity() {
    return _buildSection(
      title: 'Quy định về tài khoản và bảo mật thông tin',
      children: [
        Text(
          'Để sử dụng dịch vụ AI-Learning của FTES, mỗi học viên phải đăng ký 1 tài khoản để có thể truy cập và sử dụng. Khi học viên đăng ký tài khoản, học viên cam kết đã tuân thủ quy định, điều khoản của FTES, đồng thời tất cả các thông tin bạn cung cấp cho FTES là đúng, chính xác, đầy đủ tại thời điểm được yêu cầu.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        _buildSubSection(
          'Lưu ý quan trọng',
          [
            'Mọi quyền lợi và nghĩa vụ của bạn sẽ căn cứ trên thông tin tài khoản bạn đã đăng ký, do đó nếu có bất kỳ thông tin sai lệch nào FTES sẽ không chịu trách nhiệm trong trường hợp thông tin đó làm ảnh hưởng hoặc hạn chế quyền lợi của học viên.',
            'Mỗi học viên sở hữu 1 tài khoản bao gồm tên đăng nhập, mật khẩu; hoặc tài khoản Google, có giá trị và hiệu lực kể từ thời điểm học viên đăng ký lần đầu tiên.',
            'Sau khi đăng ký, học viên đồng ý nhận thông báo, email hoặc các hình thức truyền thông khác về sản phẩm và dịch vụ của FTES. Nếu không muốn tiếp tục nhận email, bạn có thể sử dụng chức năng \'hủy đăng ký\' ở cuối mỗi email của FTES.',
          ],
        ),
        _buildSubSection(
          'Về việc thay đổi thông tin đã đăng ký',
          [
            'Email đã đăng ký sẽ không được thay đổi trong suốt quá trình học.',
            'Trường hợp học viên cá nhân được mời vào tài khoản doanh nghiệp, khách hàng phải sử dụng email có domain của công ty hoặc email cá nhân.',
            'Nếu nghỉ việc và đang sử dụng email công ty, khách hàng cần đổi sang email cá nhân để duy trì tài khoản. Tuy nhiên, các bài học trước đó do công ty mua sẽ không thể tiếp tục truy cập.',
          ],
        ),
      ],
    );
  }

  Widget _buildPricing() {
    return _buildSection(
      title: 'Về mức giá và phương thức thanh toán',
      children: [
        Text(
          'Mức giá của từng khóa học công bố trên trang web đã bao gồm VAT, có thể thay đổi tuỳ theo chính sách giá của FTES và được cập nhật trên trang web.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        _buildSubSection(
          'Phương thức thanh toán',
          [
            'Thanh toán trực tiếp trên website theo hướng dẫn.',
            'Thanh toán QR - Mã QR thanh toán trên website',
            'Smart Banking - App ngân hàng điện tử',
            'Ví điện tử - Momo, Viettel Pay...',
          ],
        ),
        _buildSubSection(
          'Lưu ý về thanh toán',
          [
            'Học viên phải chịu phí thanh toán (nếu có)',
            'Học viên được yêu cầu đọc kỹ và hiểu các Điều Khoản và quy định trước khi thanh toán',
            'Trường hợp học viên gửi thanh toán nhưng không thành công, bạn cần chụp minh chứng giao dịch và gửi về cho FTES. Sau khi kiểm tra và xác nhận trên hệ thống, nếu đúng, FTES sẽ hoàn tiền hoặc hỗ trợ mua khóa học theo nguyện vọng của bạn',
          ],
        ),
      ],
    );
  }

  Widget _buildDisclaimer() {
    return _buildSection(
      title: 'Miễn trừ trách nhiệm',
      children: [
        Text(
          'FTES không tuyên bố hoặc bảo đảm rằng dịch vụ AI-Learning sẽ không bị lỗi, gián đoạn, hoặc rằng mọi lỗi sẽ được khắc phục.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'FTES không cam kết rằng mọi thông tin, hướng dẫn hoặc nội dung được cung cấp trong dịch vụ là chính xác, đầy đủ hoặc hữu ích trong thời điểm học hiện tại của bạn.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Bằng việc truy cập hoặc sử dụng dịch vụ, học viên tuyên bố và bảo đảm rằng hoạt động của mình là hợp pháp tại mọi khu vực pháp lý liên quan.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Một số khu vực pháp lý có thể giới hạn hoặc không cho phép áp dụng toàn bộ các tuyên bố miễn trừ trách nhiệm nêu trên. Trong những trường hợp này, việc miễn trừ trách nhiệm của FTES sẽ được điều chỉnh theo phạm vi mà pháp luật của khu vực pháp lý đó cho phép.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildComplaints() {
    return _buildSection(
      title: 'Quy định giải quyết khiếu nại',
      children: [
        Text(
          'FTES ưu tiên giải quyết mọi tranh chấp, khiếu nại, hoặc bất đồng giữa học viên và FTES thông qua thương lượng, hòa giải trên tinh thần hợp tác và tôn trọng quyền lợi đôi bên.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        _buildSubSection(
          'Quy trình khiếu nại',
          [
            'Học viên gửi khiếu nại qua các kênh hỗ trợ chính thức của FTES trong thời hạn 07 ngày làm việc kể từ khi phát sinh sự việc.',
            'Khi gửi khiếu nại, học viên cần cung cấp đầy đủ: Thông tin cá nhân (họ tên, email đăng ký tài khoản, số điện thoại liên hệ); Mô tả chi tiết sự việc; Tài liệu, chứng cứ liên quan (hóa đơn thanh toán, ảnh chụp màn hình, video, email trao đổi…)',
            'Bộ phận chuyên trách sẽ tiến hành kiểm tra thông tin, xác minh sự việc và yêu cầu học viên bổ sung thông tin (nếu cần).',
          ],
        ),
      ],
    );
  }

  Widget _buildEffectiveness() {
    return _buildSection(
      title: 'Hiệu lực',
      children: [
        Text(
          'Các điều khoản và điều kiện này có hiệu lực kể từ ngày được công bố trên trang web chính thức của FTES và thay thế cho tất cả các phiên bản, thỏa thuận hoặc cam kết trước đó (nếu có) liên quan đến cùng nội dung.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'FTES có quyền sửa đổi, bổ sung hoặc cập nhật các điều khoản và điều kiện này bất kỳ lúc nào để phù hợp với chính sách hoạt động hoặc yêu cầu pháp luật, và phải thông báo trên các trang thông tin chính thức để học viên được nắm.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Học viên có trách nhiệm thường xuyên kiểm tra các cập nhật; việc tiếp tục sử dụng dịch vụ sau khi điều khoản được cập nhật đồng nghĩa với việc học viên chấp nhận các thay đổi đó.',
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF545454),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildContact() {
    return _buildSection(
      title: 'Thông tin liên hệ',
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Công ty TNHH Giải pháp Công nghệ Giáo dục FTES',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF202244),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.location_on,
                'Địa chỉ',
                'Tổ dân phố Tân Hoà, Phường An Bình, Tỉnh Gia Lai.',
              ),
              _buildContactItem(
                Icons.phone,
                'Điện thoại',
                '0326 359 014 (Mr. Khoa)',
              ),
              const SizedBox(height: 12),
              Text(
                'Nếu bạn có câu hỏi về Điều Khoản Dịch Vụ AI-Learning FTES, vui lòng truy cập vào mục liên hệ để được giải đáp nhanh nhất.',
                style: AppTextStyles.body1.copyWith(
                  color: const Color(0xFF545454),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.heading1.copyWith(
            color: const Color(0xFF202244),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSubSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.body1.copyWith(
            color: const Color(0xFF0961F5),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 4,
                margin: const EdgeInsets.only(top: 8, right: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF0961F5),
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.body1.copyWith(
                    color: const Color(0xFF545454),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildConceptItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE8F1FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF0961F5),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF0961F5),
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: AppTextStyles.body1.copyWith(
              color: const Color(0xFF545454),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body1.copyWith(
                color: const Color(0xFF545454),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

